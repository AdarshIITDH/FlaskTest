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
