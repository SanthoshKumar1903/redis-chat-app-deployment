pipeline {
    agent { 
        label 'Bond'
    }

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

        stage('Build & Publish Docker Image to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                echo "ECR login Successfull"
                docker build -t ${ECR_REPO_NAME}:${BUILD_NUMBER} .
                docker tag ${ECR_REPO_NAME}:${BUILD_NUMBER} ${ECR_REGISTRY}/${ECR_REPO_NAME}:${BUILD_NUMBER}
                docker tag ${ECR_REPO_NAME}:${BUILD_NUMBER} ${ECR_REGISTRY}/${ECR_REPO_NAME}:latest
                docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:latest
                docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:${BUILD_NUMBER}
                echo "Build and push completed"
                """
            }
        }

        stage('Deploy to kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-admin',variable: 'KUBECONFIG')]) {
                    sh """
                      kubectl version --client
                      kubectl get nodes
                      kubectl apply -f k8s/
                    """
                }
            }
        }
    }
}
