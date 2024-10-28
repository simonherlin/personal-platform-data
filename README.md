# Personal platform data

### Introduction

Ce dépôt contient l'infrastructure nécessaire pour lancer un environnement cloud interne pour les projets de data science. Cette infrastructure comprend :

- Un service de stockage S3 (MinIO) pour stocker les artefacts,
- Une base de données MySQL pour MLflow,
- Une base de données PostgreSQL pour ZenML,
- Un serveur MLflow pour le suivi des expérimentations,
- Un serveur ZenML pour l'orchestration des pipelines,
- Un serveur Jenkins pour l'automatisation des pipelines CI/CD.

L'ensemble des services est configuré pour stocker les données de manière persistante, même en cas de redémarrage des conteneurs.

---

### Structure du dépöt

```bash
infra_internal_cloud
├── create_bucket.py                # Script Python pour créer un bucket S3
├── docker-compose.yml              # Configuration Docker Compose
├── Makefile                        # Fichier Makefile pour simplifier les commandes
├── mlflow
│   └── Dockerfile                  # Dockerfile pour le serveur MLflow
├── quickstart
│   └── mlflow_tracking.py          # Script de test pour MLflow
├── .env                            # Fichier de configuration des variables d'environnement
└── README.md                       # Documentation du projet
```

---

Prérequis
- Docker et Docker compose
- python 3.x

---


Configuration

Avant de lancer l'infrastructure, créez un fichier .env à la racine du projet pour stocker les variables d'environnement nécessaires. Voici un exemple de contenu pour ce fichier :
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
***Remarque*** : Assurez-vous de personnaliser les valeurs des variables d'environnement selon vos besoins.

---
### Commandes du Makfile

Le Makefile inclus dans ce dépôt facilite la gestion des services et des configurations. Voici les commandes disponibles :

- ***Chargement des variables d'environnement :***
```bash
make install_env_vars
```
- ***Création du Bucket S3 pour MLflow et ZenML :***
```bash
make create_bucket
```
- ***Démarrage des services :***
```bash
make up
```
- ***Arrêt des services :***
```bash
make down
```
- ***Redémarrage des services :***
```bash
make restart
```

---
### Démarrage Rapide

1. ***Charger les variables d'environnement dans votre shell pour les utiliser dans Docker :***
```bash
make install_env_vars
```
2. ***Démarrer les services avec Docker Compose :***
```bash
make up
```
Une fois que tous les services sont en place, vous pouvez accéder aux différentes interfaces via les liens suivants :
- ***MLflow :*** http://localhost:5000
- ***ZenML :*** http://localhost:9002
- ***Jenkins :*** http://localhost:8080
- ***MinIO Console :*** http://localhost:9011

3. ***Tester le suivi MLflow avec le script quickstart/mlflow_tracking.py :***
```bash
python quickstart/mlflow_tracking.py
```

---

### Volumes Persistants

Pour garantir que les données de chaque service soient conservées même après un redémarrage, chaque service utilise un volume Docker dédié :
- ***MinIO :*** minio_data
- ***PostgreSQL (ZenML) :*** postgres_data
- ***Jenkins :*** jenkins_data

### Arrêt des Services

Pour arrêter et supprimer tous les services (y compris les volumes persistants), exécutez la commande suivante à la racine du projet :
```bash
make down
```
