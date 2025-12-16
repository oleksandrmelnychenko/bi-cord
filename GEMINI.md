# Project Overview

This project is a comprehensive on-premises Business Intelligence (BI) and Artificial Intelligence (AI) platform. It's designed to consume data from an operational SQL Server database and provide advanced analytics, including AI-powered product search, demand forecasting, personalized recommendations, and automated reports.

The platform is built on a modern data stack, primarily using Python. Key technologies include:

*   **Data Ingestion:** Debezium and Kafka for real-time Change Data Capture (CDC).
*   **Data Storage:** MinIO for object storage and PostgreSQL with the `pgvector` extension for storing vector embeddings.
*   **Data Transformation:** `dbt` for building and managing data models.
*   **Orchestration:** Prefect for scheduling and monitoring data pipelines.
*   **Machine Learning:** `sentence-transformers` for generating embeddings for semantic search, and other libraries for forecasting and recommendations.
*   **API:** FastAPI to serve the AI/ML models and provide a search API.
*   **BI & Visualization:** Apache Superset for creating interactive dashboards.
*   **Infrastructure:** Docker and Docker Compose for containerization and local development.

# Building and Running

The `README.md` file provides detailed instructions for setting up the development environment and running the project. Here's a summary of the key commands:

1.  **Create a virtual environment and install dependencies:**

    ```bash
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    ```

2.  **Launch the local stack (Kafka, MinIO, pgvector, Prefect):**

    ```bash
    docker compose -f infra/docker-compose.dev.yml up -d
    ```

3.  **Run the Prefect flow to ingest data:**

    ```bash
    prefect deployment build src/ingestion/prefect_flows/kafka_to_minio.py:kafka_to_minio_flow -n product-cdc
    prefect deployment apply kafka_to_minio_flow-deployment.yaml
    prefect deployment run kafka-to-minio-flow/product-cdc
    ```

4.  **Run the `dbt` models to transform the data:**

    ```bash
    dbt run
    ```

5.  **Generate embeddings for semantic search (if not already done):**

    ```bash
    ./venv-py311/bin/python -c "from src.ml.embedding_pipeline import main; main()"
    ```

6.  **Start the ML search API server:**

    ```bash
    ./venv-py311/bin/uvicorn src.api.search_api:app --host 0.0.0.0 --port 8000
    ```

# Development Conventions

*   **Python-centric:** The project is primarily written in Python.
*   **Infrastructure as Code:** Docker and Docker Compose are used to define and manage the local development environment.
*   **Data Modeling:** `dbt` is used for version-controlled, modular, and testable SQL transformations.
*   **API Development:** FastAPI is used to build high-performance, asynchronous APIs with automatic documentation.
*   **Orchestration:** Prefect is used to orchestrate complex data pipelines.
*   **Documentation:** The `docs` directory contains extensive documentation on the architecture, data pipeline, and various components of the system.
