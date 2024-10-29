# Personal platform data

### Introduction

This repository contains the infrastructure required to launch an internal cloud environment for data science projects. This setup includes:

- An S3 storage service (MinIO) for storing artifacts,
- A PostgreSQL database for ZenML,
- An MLflow server for experiment tracking,
- A ZenML server for pipeline orchestration,
- A Jenkins server for CI/CD pipeline automation.

All services are configured to store data persistently, ensuring data is retained even if the containers are restarted.

---

### Structure du dépöt

```bash
infra_internal_cloud
├── create_bucket.py                # Python script to create an S3 bucket
├── docker-compose.yml              # Docker Compose configuration
├── Makefile                        # Makefile to simplify commands
├── mlflow
│   └── Dockerfile                  # Dockerfile for the MLflow server
├── quickstart
│   └── mlflow_tracking.py          # Test script for MLflow
├── .env                            # Environment variable configuration file
└── README.md                       # Project documentation
                    # Documentation du projet
```

---

### Prerequisites
- Docker et Docker compose
- python 3.x

---


Configuration

Before launching the infrastructure, create an .env file at the project root to store the necessary environment variables. Here is an example of what this file should contain:
```dotenv
AWS_ACCESS_KEY_ID=admin
AWS_SECRET_ACCESS_KEY=sample_key
AWS_REGION=us-east-1
AWS_BUCKET_NAME=mlflow
MYSQL_DATABASE=mlflow
MYSQL_USER=mlflow_user
MYSQL_PASSWORD=mlflow_password
MYSQL_ROOT_PASSWORD=toor
MLFLOW_S3_ENDPOINT_URL=http://localhost:9000
MLFLOW_TRACKING_URI=http://localhost:5000
ZENML_TRACKING_DB_URI=postgresql://zenml_user:zenml_password@localhost:5433/zenml
ZENML_ARTIFACT_STORE_URI=s3://mlflow/zenml-artifacts
```
***Note***: Make sure to customize the environment variable values according to your requirements.

---
### Makefile Commands

The Makefile in this repository simplifies the management of services and configurations. Here are the available commands:

- ***Load environment variables:***
```bash
make install_env_vars
```
- ***Create the S3 Bucket for MLflow and ZenML:***
```bash
make create_bucket
```
- ***Start services:***
```bash
make up
```
- ***Stop services:***
```bash
make down
```
- ***Restart services:***
```bash
make restart
```

---
### Quick Start

1. ***Load environment variables into your shell to use in Docker:***
```bash
make install_env_vars
```
2. ***Start services with Docker Compose:***
```bash
make up
```
Once all services are up, you can access the various interfaces via the following links:
- ***MLflow :*** http://localhost:5000
- ***ZenML :*** http://localhost:9002
- ***Jenkins :*** http://localhost:8080
- ***MinIO Console :*** http://localhost:9011

3. ***Test MLflow tracking with the quickstart/mlflow_tracking.py script:***
```bash
python quickstart/mlflow_tracking.py
```

---

### Persistent Volumes

To ensure that data for each service is retained even after a restart, each service uses a dedicated Docker volume:
- ***MinIO :*** minio_data
- ***PostgreSQL (ZenML) :*** postgres_data
- ***Jenkins :*** jenkins_data

### Stopping Services

To stop and remove all services (including persistent volumes), run the following command at the project root:
```bash
make down
```
