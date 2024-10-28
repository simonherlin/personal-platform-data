install_env_vars:
	echo "export $(cat .env | xargs)" >> ~/.bashrc

# Afficher les variables d'environnement
print_env_vars:
	@echo "Variables d'environnement chargées :"
	@cat .env

# Créer le bucket S3
create_bucket:
	docker-compose run --rm create_s3_buckets

# Démarrer les services
up:
	docker-compose up -d

# Arrêter les services
down:
	docker-compose down -v

# Redémarrer les services
restart:
	docker-compose down -v && docker-compose up -d
