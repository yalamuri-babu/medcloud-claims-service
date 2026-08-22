pipeline {
    agent {
        label 'medcloud-dev'
    }

    environment {
        IMAGE_NAME = 'medcloud-claims-service'
    }

    stages {

        stage('Build Host') {
            steps {
                sh '''
                    echo "===== BUILD HOST ====="
                    hostname
                '''
            }
        }

        stage('Java & Maven') {
            steps {
                sh '''
                    echo "===== JAVA ====="
                    java -version

                    echo "===== MAVEN WRAPPER ====="
                    ./mvnw -version
                '''
            }
        }

        stage('Build & Test') {
            steps {
                sh '''
                    echo "===== MAVEN BUILD & TEST ====="
                    ./mvnw clean test
                '''
            }
        }

        stage('Package') {
            steps {
                sh '''
                    echo "===== MAVEN PACKAGE ====="
                    ./mvnw package -DskipTests
                '''
            }
        }

        stage('Verify Artifact') {
            steps {
                sh '''
                    echo "===== VERIFY JAR ====="
                    ls -lh target/*.jar
                '''
            }
        }

        stage('Set Image Tag') {
            steps {
                script {
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short=8 HEAD',
                        returnStdout: true
                    ).trim()
                }

                sh '''
                    echo "===== DOCKER IMAGE TAG ====="
                    echo "${IMAGE_NAME}:${IMAGE_TAG}"
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "===== DOCKER VERSION ====="
                    docker --version

                    echo "===== DOCKER BUILD ====="
                    docker build \
                      -t ${IMAGE_NAME}:${IMAGE_TAG} \
                      .
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh '''
                    echo "===== VERIFY DOCKER IMAGE ====="

                    docker image inspect \
                      ${IMAGE_NAME}:${IMAGE_TAG} \
                      --format='Image ID: {{.Id}}'

                    docker images ${IMAGE_NAME}
                '''
            }
        }
    }

    post {
        success {
            echo '===== CI RESULT ====='
            echo 'BUILD, TESTS, PACKAGE AND DOCKER IMAGE PASSED'
        }

        failure {
            echo '===== CI RESULT ====='
            echo 'BUILD, TEST, PACKAGE OR DOCKER IMAGE FAILED'
        }
    }
}
