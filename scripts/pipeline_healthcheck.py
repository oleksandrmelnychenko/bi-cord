#!/usr/bin/env python3
"""
End-to-end health check for the product ingestion pipeline.

This script validates that:
  * Required environment variables for databases and services are present.
  * Postgres is reachable using the staging connection details.
  * Bronze CDC tables for product, availability, and analogue data exist and contain rows.
  * Staging views are materialized with the expected key columns.
  * The marts.dim_product_search table is built and populated.

Usage:
    source .env            # ensure credentials are in the environment
    python scripts/pipeline_healthcheck.py

Exit code is non-zero if any critical checks fail.
"""

from __future__ import annotations

import os
import sys
import textwrap
import urllib.error
import urllib.request
from dataclasses import dataclass
from typing import Iterable, List, Optional, Sequence

import psycopg2
from psycopg2 import sql


REQUIRED_ENV_VARS = [
    "STAGING_DB_HOST",
    "STAGING_DB_PORT",
    "STAGING_DB_NAME",
    "STAGING_DB_USER",
    "STAGING_DB_PASSWORD",
    "MINIO_ENDPOINT",
    "KAFKA_BOOTSTRAP_SERVERS",
]

OPTIONAL_SERVICE_ENDPOINTS = {
    "Debezium Connect": os.getenv("DEBEZIUM_CONNECT_URL", "http://localhost:8083/connectors"),
    "Prefect API": os.getenv("PREFECT_API_URL", "http://localhost:4200/api"),
}


@dataclass
class CheckResult:
    name: str
    status: str  # "PASS", "WARN", "FAIL"
    message: str


class PipelineHealthChecker:
    def __init__(self) -> None:
        self.results: List[CheckResult] = []
        self.failures = 0
        self.warnings = 0

    def run(self) -> None:
        self._check_environment()
        conn = self._connect_postgres()
        if conn is not None:
            with conn:
                with conn.cursor() as cur:
                    self._check_bronze_tables(cur)
                    self._check_staging_views(cur)
                    self._check_mart_table(cur)
            conn.close()
        self._check_http_services()

    def summary(self) -> str:
        lines = ["", "Health Check Summary:"]
        for result in self.results:
            icon = {"PASS": "✅", "WARN": "⚠️", "FAIL": "❌"}[result.status]
            lines.append(f"  {icon} [{result.status}] {result.name}: {result.message}")

        status_line = "All checks passed."
        if self.failures:
            status_line = f"{self.failures} failure(s); inspect and fix before proceeding."
        elif self.warnings:
            status_line = f"No failures, but {self.warnings} warning(s) need attention."
        lines.append("")
        lines.append(status_line)
        return "\n".join(lines)

    def exit_code(self) -> int:
        return 1 if self.failures else 0

    # Internal helpers -------------------------------------------------
    def _check_environment(self) -> None:
        missing = [var for var in REQUIRED_ENV_VARS if not os.getenv(var)]
        if missing:
            self._record(
                "Environment Variables",
                "FAIL",
                f"Missing required variables: {', '.join(missing)}",
            )
            self.failures += 1
        else:
            self._record(
                "Environment Variables",
                "PASS",
                "All required environment variables are set.",
            )

    def _connect_postgres(self) -> Optional[psycopg2.extensions.connection]:
        try:
            conn = psycopg2.connect(
                host=os.getenv("STAGING_DB_HOST"),
                port=int(os.getenv("STAGING_DB_PORT", "5432")),
                dbname=os.getenv("STAGING_DB_NAME"),
                user=os.getenv("STAGING_DB_USER"),
                password=os.getenv("STAGING_DB_PASSWORD"),
                connect_timeout=5,
            )
        except Exception as exc:  # pragma: no cover - connectivity issues
            self._record(
                "Postgres Connection",
                "FAIL",
                f"Unable to connect to Postgres: {exc}",
            )
            self.failures += 1
            return None

        self._record(
            "Postgres Connection",
            "PASS",
            "Successfully connected to Postgres using STAGING_DB_* settings.",
        )
        return conn

    def _check_bronze_tables(self, cur: psycopg2.extensions.cursor) -> None:
        checks = [
            ("bronze", "product_cdc", 1),
            ("bronze", "product_availability_cdc", 1),
            ("bronze", "product_analogue_cdc", 1),
        ]
        for schema, table, min_rows in checks:
            if not self._table_exists(cur, schema, table):
                self._record(
                    f"{schema}.{table}",
                    "FAIL",
                    "Table not found. Ensure Debezium CDC landed raw data.",
                )
                self.failures += 1
                continue

            rowcount = self._count_rows(cur, schema, table)
            if rowcount >= min_rows:
                self._record(
                    f"{schema}.{table}",
                    "PASS",
                    f"{rowcount} row(s) available.",
                )
            else:
                self._record(
                    f"{schema}.{table}",
                    "WARN",
                    "Table exists but has no data yet.",
                )
                self.warnings += 1

    def _check_staging_views(self, cur: psycopg2.extensions.cursor) -> None:
        staging_checks = [
            ("staging", "stg_product", ["product_id", "has_analogue", "source_timestamp"]),
            ("staging", "stg_product_availability", ["product_i_d", "storage_i_d", "amount"]),
            ("staging", "stg_product_analogue", ["base_product_i_d", "analogue_product_i_d"]),
        ]
        for schema, view, expected_columns in staging_checks:
            if not self._table_exists(cur, schema, view):
                self._record(
                    f"{schema}.{view}",
                    "FAIL",
                    "View not found. Run `dbt run --models staging`.",
                )
                self.failures += 1
                continue

            available_columns = self._list_columns(cur, schema, view)
            missing_columns = [col for col in expected_columns if col not in available_columns]
            if missing_columns:
                self._record(
                    f"{schema}.{view} Columns",
                    "FAIL",
                    f"Missing columns: {', '.join(missing_columns)}",
                )
                self.failures += 1
                continue

            rowcount = self._count_rows(cur, schema, view)
            status = "PASS" if rowcount > 0 else "WARN"
            message = f"{rowcount} row(s) available." if rowcount else "No rows yet."
            self._record(f"{schema}.{view}", status, message)
            if rowcount == 0:
                self.warnings += 1

    def _check_mart_table(self, cur: psycopg2.extensions.cursor) -> None:
        schema, table = "marts", "dim_product_search"
        if not self._table_exists(cur, schema, table):
            self._record(
                f"{schema}.{table}",
                "FAIL",
                "Table not built. Run `dbt run --models marts.dim_product_search`.",
            )
            self.failures += 1
            return

        required_columns = [
            "product_id",
            "total_available_amount",
            "analogue_product_ids",
            "storage_count",
        ]
        missing_cols = [col for col in required_columns if col not in self._list_columns(cur, schema, table)]
        if missing_cols:
            self._record(
                f"{schema}.{table} Columns",
                "FAIL",
                f"Missing columns: {', '.join(missing_cols)}",
            )
            self.failures += 1
            return

        rowcount = self._count_rows(cur, schema, table)
        if rowcount > 0:
            self._record(
                f"{schema}.{table}",
                "PASS",
                f"{rowcount} row(s) ready for ML and API workloads.",
            )
        else:
            self._record(
                f"{schema}.{table}",
                "WARN",
                "Table exists but has no rows. Re-run dbt after ingestion.",
            )
            self.warnings += 1

    def _check_http_services(self) -> None:
        for name, url in OPTIONAL_SERVICE_ENDPOINTS.items():
            try:
                req = urllib.request.Request(url, method="GET")
                with urllib.request.urlopen(req, timeout=3):  # noqa: S310
                    pass
            except urllib.error.URLError:
                self._record(
                    name,
                    "WARN",
                    f"Skipped: {url} not reachable. Start the service if required.",
                )
                self.warnings += 1
            else:
                self._record(name, "PASS", f"Reachable at {url}.")

    # Database helpers -------------------------------------------------
    def _table_exists(self, cur: psycopg2.extensions.cursor, schema: str, table: str) -> bool:
        query = sql.SQL(
            """
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = %s AND table_name = %s
            LIMIT 1;
            """
        )
        cur.execute(query, (schema, table))
        return cur.fetchone() is not None

    def _list_columns(self, cur: psycopg2.extensions.cursor, schema: str, table: str) -> Sequence[str]:
        query = sql.SQL(
            """
            SELECT column_name
            FROM information_schema.columns
            WHERE table_schema = %s AND table_name = %s;
            """
        )
        cur.execute(query, (schema, table))
        return [row[0] for row in cur.fetchall()]

    def _count_rows(self, cur: psycopg2.extensions.cursor, schema: str, table: str) -> int:
        query = sql.SQL("SELECT COUNT(*) FROM {}.{};").format(
            sql.Identifier(schema),
            sql.Identifier(table),
        )
        cur.execute(query)
        count = cur.fetchone()
        return int(count[0]) if count else 0

    def _record(self, name: str, status: str, message: str) -> None:
        self.results.append(CheckResult(name=name, status=status, message=message))


def main() -> int:
    checker = PipelineHealthChecker()
    checker.run()
    print(checker.summary())
    return checker.exit_code()


if __name__ == "__main__":
    sys.exit(main())
