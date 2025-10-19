"""
Database Connection Utilities

Provides centralized database connection functions using configuration.
All database access should use these utilities instead of creating connections directly.
"""

from __future__ import annotations

from typing import Optional
from contextlib import contextmanager

import psycopg2
from psycopg2.extras import DictCursor

from src.config import get_settings


@contextmanager
def get_postgres_connection(cursor_factory=None):
    """
    Get PostgreSQL connection context manager

    Usage:
        with get_postgres_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM table")

        with get_postgres_connection(cursor_factory=DictCursor) as conn:
            cursor = conn.cursor()
            for row in cursor.fetchall():
                print(row['column_name'])

    Args:
        cursor_factory: Optional cursor factory (e.g., DictCursor)

    Yields:
        psycopg2 connection
    """
    settings = get_settings()

    conn: Optional[psycopg2.extensions.connection] = None
    try:
        conn = psycopg2.connect(
            host=settings.postgres.host,
            port=settings.postgres.port,
            database=settings.postgres.database,
            user=settings.postgres.user,
            password=settings.postgres.password,
            cursor_factory=cursor_factory,
        )
        yield conn
        conn.commit()
    except Exception:
        if conn:
            conn.rollback()
        raise
    finally:
        if conn:
            conn.close()


def get_postgres_connection_params() -> dict:
    """
    Get PostgreSQL connection parameters as dict

    Useful for libraries that accept connection params as dict.

    Returns:
        Dict with connection parameters
    """
    settings = get_settings()

    return {
        'host': settings.postgres.host,
        'port': settings.postgres.port,
        'database': settings.postgres.database,
        'user': settings.postgres.user,
        'password': settings.postgres.password,
    }


def test_postgres_connection() -> bool:
    """
    Test PostgreSQL connection

    Returns:
        True if connection successful, False otherwise
    """
    try:
        with get_postgres_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT 1")
            cursor.fetchone()
        return True
    except Exception as error:
        print(f"PostgreSQL connection test failed: {error}")
        return False


if __name__ == "__main__":
    print("Testing PostgreSQL connection...")
    if test_postgres_connection():
        print("✅ PostgreSQL connection successful")
    else:
        print("❌ PostgreSQL connection failed")
