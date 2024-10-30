export $(grep -v '^#' .env | xargs)

sudo apt update && sudo apt upgrade -y

sudo apt install -y docker.io python3 python3-pip

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y openjdk-11-jdk jenkins

sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=8081/' /etc/default/jenkins
sudo systemctl restart jenkins
sudo systemctl enable jenkins

docker run -d \
  --name postgres \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -v postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13

pip3 install zenml==0.67.0
zenml integration install -y mlflow
zenml up --docker

zenml init
zenml stack register default_stack \
    -o default \
    --artifact_store_type local \
    --metadata_store_type relational \
    --metadata_store_uri $ZENML_DB_URI \
    --experiment_tracker mlflow \
    --experiment_tracker_uri $MLFLOW_TRACKING_URI

nohup mlflow server \
  --backend-store-uri $ZENML_DB_URI \
  --default-artifact-root ./mlartifacts \
  --host 0.0.0.0 --port 5000 &

echo "Installation terminée !"
echo "Accède aux services via les URL suivantes :"
echo "ZenML : http://127.0.0.1:8238"
echo "MLflow : http://127.0.0.1:5000"
echo "Jenkins : http://127.0.0.1:8081"
