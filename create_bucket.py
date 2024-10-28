import os
from minio import Minio

accessID = os.environ.get('AWS_ACCESS_KEY_ID')
accessSecret = os.environ.get('AWS_SECRET_ACCESS_KEY')
minioUrl = os.environ.get('MLFLOW_S3_ENDPOINT_URL')
bucketName = os.environ.get('AWS_BUCKET_NAME')

if not all([accessID, accessSecret, minioUrl, bucketName]):
    print("Assurez-vous que toutes les variables d'environnement sont définies.")
    exit(1)

s3Client = Minio(
    minioUrl.replace("http://", "").replace("https://", ""),
    access_key=accessID,
    secret_key=accessSecret,
    secure=False
)

if not s3Client.bucket_exists(bucketName):
    s3Client.make_bucket(bucketName)
    print(f"Bucket '{bucketName}' créé avec succès.")
else:
    print(f"Le bucket '{bucketName}' existe déjà.")
