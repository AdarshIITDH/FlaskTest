# FlaskTest

in app.py 
```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
```

Jenkins File

```
pipeline {
    agent any

    stages {

        stage('Cloning the code') {
            steps {
                git url: 'https://github.com/AdarshIITDH/FlaskTest.git', branch: 'main'
            }
        }
        stage('Install requirements') {
            steps {
                script {
                    dir('FlaskTest') {
                        sh 'pip3 install -r requirements.txt'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    dir('FlaskTest') {
                        sh 'python3 test_app.py'
                    }
                }
            }
        }
    }
}

```
![image](https://github.com/AdarshIITDH/FlaskTest/assets/60352729/a0e66ab3-ce21-40e4-ab99-e562f6c9c039)

Docker building
as time is limited so not including the docker part in jenkins pipeline
```
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```
Application is working fine 

![image](https://github.com/AdarshIITDH/FlaskTest/assets/60352729/7a2d874f-0700-4677-abbb-921b4cf1945b)


![image](https://github.com/AdarshIITDH/FlaskTest/assets/60352729/083f55ea-7b9d-4eb3-b864-f9d5278367ec)

the whole jenkins pipeline will look like this
```
pipeline {
    agent any

    stages {

        stage('Cloning the code') {
            steps {
                git url: 'https://github.com/AdarshIITDH/FlaskTest.git', branch: 'main'
            }
        }
        stage('Install requirements') {
            steps {
                script {
                    dir('FlaskTest') {
                        sh 'pip3 install -r requirements.txt'
                        // sh 'sudo apt install python'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    dir('FlaskTest') {
                        sh 'python3 test_app.py'
                    }
                }
            }
        }
        stage('Build Docker Image') {
            when {
                allOf {
                    expression {
                        currentBuild.result == 'SUCCESS' /
                    }
                    branch 'main' 
                }
            }
            steps {
                script {
                    sh 'sudo docker build -t flasktest .'
                }
            }
        }
    }
}

```
![image](https://github.com/AdarshIITDH/FlaskTest/assets/60352729/09357ae9-5dfc-44de-aa97-216e397b8f67)

For deploying the application in kubernetes 

deployment file
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-test-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flasktest
  template:
    metadata:
      labels:
        app: flasktest
    spec:
      containers:
      - name: flask-app
        image: flasktest:latest 
        ports:
        - containerPort: 5000 

```
```
kubectl apply -f flask-test-deployment.yaml
```
after that will require to expose service so that user can access it 

```
apiVersion: v1
kind: Service
metadata:
  name: flask-test-service
spec:
  selector:
    app: flasktest
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: LoadBalancer
```
Load balancer service will enable a dns for user to hit and access the application

```
kubectl apply -f flask-test-service.yaml
```
