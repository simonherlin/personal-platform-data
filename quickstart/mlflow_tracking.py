import os
from random import random, randint
import mlflow

if __name__ == "__main__":
    mlflow.set_tracking_uri(os.getenv("MLFLOW_TRACKING_URI", "http://localhost:5000"))
    with mlflow.start_run() as run:
        print("Exécution du script de tracking MLflow")

        mlflow.log_param("param1", randint(0, 100))
        mlflow.log_metric("foo", random())
        mlflow.log_metric("foo", random() + 1)
        mlflow.log_metric("foo", random() + 2)

        if not os.path.exists("outputs"):
            os.makedirs("outputs")
        with open("outputs/test.txt", "w") as f:
            f.write("hello world!")

        mlflow.log_artifacts("outputs")
