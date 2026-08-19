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
    }

    post {
        success {
            echo '===== CI RESULT ====='
            echo 'BUILD AND TESTS PASSED'
        }

        failure {
            echo '===== CI RESULT ====='
            echo 'BUILD OR TESTS FAILED'
        }
    }
} 
