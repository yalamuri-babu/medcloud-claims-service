pipeline {
    agent {
        label 'medcloud-dev'
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
    }

    post {
        success {
            echo '===== CI RESULT ====='
            echo 'BUILD, TESTS AND PACKAGE PASSED'
        }

        failure {
            echo '===== CI RESULT ====='
            echo 'BUILD, TEST OR PACKAGE FAILED'
        }
    }
}
