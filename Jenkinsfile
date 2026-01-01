pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        AWS_REGION     = "us-east-1"
        AWS_ACCOUNT_ID = credentials('aws-account-id')
        ECR_REPO_NAME  = "my-app"
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
                sh """
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                """
            }
        }

        stage('Build & Publish Docker Image') {
            steps {
                sh """
                docker build -t $ECR_REPO_NAME .
                docker tag $ECR_REPO_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest
                docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest
                """
            }
        }
    }
}
