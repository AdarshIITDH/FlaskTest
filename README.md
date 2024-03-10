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

```


```





