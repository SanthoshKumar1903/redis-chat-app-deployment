pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        AWS_REGION     = "us-east-1"
        AWS_ACCOUNT_ID = credentials('aws-account-id')
        ECR_REPO_NAME  = "python-chat-app"
        ECR_REGISTRY   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        REPO_URL       = "https://github.com/SanthoshKumar1903/redis-chat-app-deployment"
    }

    stages {
        stage('Source Checkout') {
            steps {
                git branch: 'master', url: "${REPO_URL}"
            }
        }

        stage('Authenticate with ECR') {
            steps {
                try {
                    sh """
                    aws ecr get-login-password --region $AWS_REGION \
                    | docker login --username AWS --password-stdin $ECR_REGISTRY
                    """
                    }
                } catch (Exception e) {
                    echo "ECR Login failed: ${e.message}"
                    error("ECR Authentication failed")
                }
        }

        stage('Build & Publish Docker Image') {
            steps {
                sh """
                docker build -t $ECR_REPO_NAME .
                docker tag $ECR_REPO_NAME:latest $ECR_REGISTRY/$ECR_REPO_NAME:latest
                docker push $ECR_REGISTRY/$ECR_REPO_NAME:latest
                """
            }
        }
    }
}
