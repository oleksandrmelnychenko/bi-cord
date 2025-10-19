"""
Application Settings

Centralized configuration using environment variables with validation.
Uses pydantic-settings for type safety and validation.

Usage:
    from src.config import get_settings

    settings = get_settings()
    conn = psycopg2.connect(
        host=settings.postgres.host,
        port=settings.postgres.port,
        database=settings.postgres.database,
        user=settings.postgres.user,
        password=settings.postgres.password,
    )
"""

from __future__ import annotations

import os
from functools import lru_cache
from typing import Optional, Literal

try:
    from pydantic_settings import BaseSettings
    from pydantic import Field, validator
except ImportError:
    from pydantic import BaseSettings, Field, validator


class PostgresSettings(BaseSettings):
    """PostgreSQL database configuration"""

    host: str = Field(default="localhost", env="POSTGRES_HOST")
    port: int = Field(default=5433, env="POSTGRES_PORT")
    database: str = Field(default="analytics", env="POSTGRES_DB")
    user: str = Field(default="analytics", env="POSTGRES_USER")
    password: str = Field(default="analytics", env="POSTGRES_PASSWORD")

    class Config:
        env_prefix = "POSTGRES_"
        case_sensitive = False


class KafkaSettings(BaseSettings):
    """Kafka configuration"""

    bootstrap_servers: str = Field(default="localhost:9092", env="KAFKA_BOOTSTRAP_SERVERS")
    topic_product: str = Field(default="cord.ConcordDb.dbo.Product", env="KAFKA_TOPIC_PRODUCT")
    consumer_group_prefix: str = Field(default="bi-platform", env="KAFKA_CONSUMER_GROUP_PREFIX")
    auto_offset_reset: Literal["earliest", "latest"] = Field(default="earliest", env="KAFKA_AUTO_OFFSET_RESET")

    class Config:
        env_prefix = "KAFKA_"
        case_sensitive = False


class MinIOSettings(BaseSettings):
    """MinIO S3-compatible storage configuration"""

    endpoint: str = Field(default="localhost:9000", env="MINIO_ENDPOINT")
    access_key: str = Field(default="minioadmin", env="MINIO_ACCESS_KEY")
    secret_key: str = Field(default="minioadmin", env="MINIO_SECRET_KEY")
    secure: bool = Field(default=False, env="MINIO_SECURE")
    bucket_raw: str = Field(default="cord-raw", env="MINIO_BUCKET_RAW")

    class Config:
        env_prefix = "MINIO_"
        case_sensitive = False


class SQLServerSettings(BaseSettings):
    """SQL Server source database configuration"""

    host: str = Field(default="localhost", env="SQLSERVER_HOST")
    port: int = Field(default=1433, env="SQLSERVER_PORT")
    database: str = Field(default="ConcordDb", env="SQLSERVER_DATABASE")
    user: str = Field(default="sa", env="SQLSERVER_USER")
    password: str = Field(default="", env="SQLSERVER_PASSWORD")
    driver: str = Field(default="ODBC Driver 17 for SQL Server", env="SQLSERVER_DRIVER")

    class Config:
        env_prefix = "SQLSERVER_"
        case_sensitive = False


class MLSettings(BaseSettings):
    """Machine Learning configuration"""

    # Embedding model
    embedding_model: str = Field(
        default="sentence-transformers/all-MiniLM-L6-v2",
        env="ML_EMBEDDING_MODEL"
    )
    embedding_dimension: int = Field(default=384, env="ML_EMBEDDING_DIMENSION")

    # Device configuration
    device: Literal["cpu", "cuda", "mps", "auto"] = Field(default="auto", env="ML_DEVICE")
    batch_size: int = Field(default=32, env="ML_BATCH_SIZE")

    # Embedding pipeline
    embedding_chunk_size: int = Field(default=1000, env="ML_EMBEDDING_CHUNK_SIZE")
    enable_watermark: bool = Field(default=True, env="ML_ENABLE_WATERMARK")

    class Config:
        env_prefix = "ML_"
        case_sensitive = False


class APISettings(BaseSettings):
    """FastAPI application configuration"""

    host: str = Field(default="0.0.0.0", env="API_HOST")
    port: int = Field(default=8000, env="API_PORT")
    workers: int = Field(default=1, env="API_WORKERS")
    reload: bool = Field(default=False, env="API_RELOAD")
    log_level: Literal["debug", "info", "warning", "error", "critical"] = Field(
        default="info",
        env="API_LOG_LEVEL"
    )

    # CORS
    cors_origins: list = Field(default=["*"], env="API_CORS_ORIGINS")

    # Request limits
    max_query_length: int = Field(default=500, env="API_MAX_QUERY_LENGTH")
    max_results: int = Field(default=100, env="API_MAX_RESULTS")
    default_results: int = Field(default=20, env="API_DEFAULT_RESULTS")

    class Config:
        env_prefix = "API_"
        case_sensitive = False


class ObservabilitySettings(BaseSettings):
    """Observability and monitoring configuration"""

    # Sentry
    sentry_dsn: Optional[str] = Field(default=None, env="SENTRY_DSN")
    sentry_environment: str = Field(default="development", env="SENTRY_ENVIRONMENT")
    sentry_traces_sample_rate: float = Field(default=0.1, env="SENTRY_TRACES_SAMPLE_RATE")

    # Prometheus
    prometheus_enabled: bool = Field(default=False, env="PROMETHEUS_ENABLED")
    prometheus_port: int = Field(default=9090, env="PROMETHEUS_PORT")

    # Logging
    log_level: Literal["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"] = Field(
        default="INFO",
        env="LOG_LEVEL"
    )
    log_format: Literal["json", "text"] = Field(default="text", env="LOG_FORMAT")

    class Config:
        env_prefix = "OBSERVABILITY_"
        case_sensitive = False


class Settings(BaseSettings):
    """Main application settings"""

    # Environment
    environment: Literal["development", "staging", "production"] = Field(
        default="development",
        env="ENVIRONMENT"
    )
    debug: bool = Field(default=False, env="DEBUG")

    # Component settings
    postgres: PostgresSettings = Field(default_factory=PostgresSettings)
    kafka: KafkaSettings = Field(default_factory=KafkaSettings)
    minio: MinIOSettings = Field(default_factory=MinIOSettings)
    sqlserver: SQLServerSettings = Field(default_factory=SQLServerSettings)
    ml: MLSettings = Field(default_factory=MLSettings)
    api: APISettings = Field(default_factory=APISettings)
    observability: ObservabilitySettings = Field(default_factory=ObservabilitySettings)

    # Project info
    project_name: str = Field(default="BI Platform", env="PROJECT_NAME")
    version: str = Field(default="1.0.0", env="VERSION")

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = False

    @validator('environment')
    def validate_environment(cls, value: str) -> str:
        """Validate environment value"""
        allowed: list = ["development", "staging", "production"]
        if value not in allowed:
            raise ValueError(f"Environment must be one of {allowed}, got {value}")
        return value

    def get_postgres_uri(self, async_driver: bool = False) -> str:
        """Generate PostgreSQL connection URI"""
        driver: str = "postgresql+asyncpg" if async_driver else "postgresql"
        return (
            f"{driver}://{self.postgres.user}:{self.postgres.password}"
            f"@{self.postgres.host}:{self.postgres.port}/{self.postgres.database}"
        )

    def get_sqlserver_connection_string(self) -> str:
        """Generate SQL Server connection string"""
        return (
            f"DRIVER={{{self.sqlserver.driver}}};"
            f"SERVER={self.sqlserver.host},{self.sqlserver.port};"
            f"DATABASE={self.sqlserver.database};"
            f"UID={self.sqlserver.user};"
            f"PWD={self.sqlserver.password};"
            f"TrustServerCertificate=yes;"
        )

    def is_production(self) -> bool:
        """Check if running in production"""
        return self.environment == "production"

    def is_development(self) -> bool:
        """Check if running in development"""
        return self.environment == "development"


@lru_cache()
def get_settings() -> Settings:
    """
    Get cached settings instance

    Uses LRU cache to ensure settings are only loaded once.
    Call this function instead of instantiating Settings directly.

    Returns:
        Settings instance
    """
    return Settings()


def validate_settings() -> None:
    """
    Validate all required settings are present

    Call this at application startup to fail fast if configuration is invalid.

    Raises:
        ValueError: If required settings are missing or invalid
    """
    settings: Settings = get_settings()

    errors: list = []

    if settings.is_production():
        if settings.postgres.password == "analytics":
            errors.append("Production requires custom POSTGRES_PASSWORD")

        if settings.minio.access_key == "minioadmin":
            errors.append("Production requires custom MINIO_ACCESS_KEY")

        if settings.sqlserver.password == "":
            errors.append("Production requires SQLSERVER_PASSWORD")

    if errors:
        error_msg: str = "\n".join(f"  - {error}" for error in errors)
        raise ValueError(f"Configuration validation failed:\n{error_msg}")

    print(f"Configuration validated successfully for environment: {settings.environment}")


if __name__ == "__main__":
    settings: Settings = get_settings()
    print(f"Environment: {settings.environment}")
    print(f"PostgreSQL: {settings.postgres.host}:{settings.postgres.port}/{settings.postgres.database}")
    print(f"Kafka: {settings.kafka.bootstrap_servers}")
    print(f"MinIO: {settings.minio.endpoint}")
    print(f"ML Device: {settings.ml.device}")
    print(f"API: {settings.api.host}:{settings.api.port}")
