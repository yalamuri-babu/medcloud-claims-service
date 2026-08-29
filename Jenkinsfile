pipeline {
    agent {
        label 'medcloud-dev'
    }

    environment {
        IMAGE_NAME = 'medcloud-claims-service'
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '776751404462'
        ECR_REPOSITORY = 'medcloud-claims-service'
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

        stage('ECR Login') {
            when {
                branch 'main'
            }

            steps {
                sh '''
                    echo "===== ECR LOGIN ====="

                    ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

                    aws ecr get-login-password \
                      --region ${AWS_REGION} \
                    | docker login \
                      --username AWS \
                      --password-stdin \
                      ${ECR_REGISTRY}
                '''
            }
        }

        stage('ECR Tag') {
            when {
                branch 'main'
            }

            steps {
                sh '''
                    echo "===== ECR TAG ====="

                    ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    ECR_IMAGE="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

                    echo "Local image:"
                    echo "${IMAGE_NAME}:${IMAGE_TAG}"

                    echo "ECR image:"
                    echo "${ECR_IMAGE}"

                    docker tag \
                      ${IMAGE_NAME}:${IMAGE_TAG} \
                      ${ECR_IMAGE}
                '''
            }
        }

        stage('ECR Push') {
            when {
                branch 'main'
            }

            steps {
                sh '''
                    echo "===== ECR PUSH ====="

                    ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    ECR_IMAGE="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

                    docker push ${ECR_IMAGE}
                '''
            }
        }

        stage('Verify ECR Image') {
            when {
                branch 'main'
            }

            steps {
                sh '''
                    echo "===== VERIFY ECR IMAGE ====="

                    aws ecr describe-images \
                      --region ${AWS_REGION} \
                      --repository-name ${ECR_REPOSITORY} \
                      --image-ids imageTag=${IMAGE_TAG}
                '''
            }
        }
stage('ECR Security Scan') {
    when {
        branch 'main'
    }

    steps {
        sh '''
            echo "===== ECR SECURITY SCAN ====="
            echo "Waiting for ECR scan to become available..."

            SCAN_READY=false

            for ATTEMPT in $(seq 1 30); do

                STATUS=$(aws ecr describe-image-scan-findings \
                  --region ${AWS_REGION} \
                  --repository-name ${ECR_REPOSITORY} \
                  --image-id imageTag=${IMAGE_TAG} \
                  --query 'imageScanStatus.status' \
                  --output text 2>/dev/null || true)

                echo "Attempt ${ATTEMPT}: scan status = ${STATUS:-NOT_AVAILABLE}"

                if [ "$STATUS" = "COMPLETE" ]; then
                    SCAN_READY=true
                    break
                fi

                if [ "$STATUS" = "FAILED" ]; then
                    echo "ECR vulnerability scan FAILED"
                    exit 1
                fi

                sleep 5
            done

            if [ "$SCAN_READY" != "true" ]; then
                echo "Security scan did not complete within expected time."
                exit 1
            fi

            echo "===== VULNERABILITY COUNTS ====="

            COUNTS=$(aws ecr describe-image-scan-findings \
              --region ${AWS_REGION} \
              --repository-name ${ECR_REPOSITORY} \
              --image-id imageTag=${IMAGE_TAG} \
              --query '[imageScanFindings.findingSeverityCounts.CRITICAL,
                        imageScanFindings.findingSeverityCounts.HIGH,
                        imageScanFindings.findingSeverityCounts.MEDIUM,
                        imageScanFindings.findingSeverityCounts.LOW,
                        imageScanFindings.findingSeverityCounts.INFORMATIONAL]' \
              --output text)

            set -- $COUNTS

            CRITICAL=$1
            HIGH=$2
            MEDIUM=$3
            LOW=$4
            INFO=$5

            [ "$CRITICAL" = "None" ] && CRITICAL=0
            [ "$HIGH" = "None" ] && HIGH=0
            [ "$MEDIUM" = "None" ] && MEDIUM=0
            [ "$LOW" = "None" ] && LOW=0
            [ "$INFO" = "None" ] && INFO=0

            echo "Critical : $CRITICAL"
            echo "High     : $HIGH"
            echo "Medium   : $MEDIUM"
            echo "Low      : $LOW"
            echo "Info     : $INFO"

            echo "===== SECURITY POLICY ====="

            if [ "$CRITICAL" -gt 0 ]; then
                echo "SECURITY GATE FAILED"
                echo "Critical vulnerabilities detected: $CRITICAL"
                exit 1
            fi

            if [ "$HIGH" -gt 0 ]; then
                echo "WARNING: $HIGH HIGH vulnerabilities detected."
                echo "Security review is required."
            fi

            echo "SECURITY GATE PASSED"
        '''
    }
}
}
    post {
        success {
            echo '===== CI RESULT ====='
            echo 'CI PIPELINE PASSED'
        }

        failure {
            echo '===== CI RESULT ====='
            echo 'CI PIPELINE FAILED'
        }
    }
}
