pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1' // Change to your AWS region if needed
        AWS_ACCOUNT_ID = '<YOUR_AWS_ACCOUNT_ID>' // Replace with your AWS Account ID
        ECR_REGISTRY = "${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    // Builds container images defined in your docker-compose.yml
                    sh 'docker compose build'
                }
            }
        }

        stage('Authenticate with Amazon ECR') {
            steps {
                script {
                    // Authenticates Docker to push images to your private AWS ECR repository
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                }
            }
        }

        stage('Push Images to ECR') {
            steps {
                script {
                    // Tag and push each microservice image to ECR
                    // Ensure your ECR repositories (user-service, product-service, order-service) are created in AWS
                    sh '''
                        docker tag microservices-devops-assignment-user:latest ${ECR_REGISTRY}/user-service:latest
                        docker push ${ECR_REGISTRY}/user-service:latest

                        docker tag microservices-devops-assignment-product:latest ${ECR_REGISTRY}/product-service:latest
                        docker push ${ECR_REGISTRY}/product-service:latest

                        docker tag microservices-devops-assignment-order:latest ${ECR_REGISTRY}/order-service:latest
                        docker push ${ECR_REGISTRY}/order-service:latest
                    '''
                }
            }
        }

        stage('Deploy to EC2 via Docker Compose') {
            steps {
                script {
                    // Restart containers to pull and run the newly deployed images
                    sh 'docker compose down && docker compose up -d'
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully! Microservices are deployed and running.'
        }
        failure {
            echo 'CI/CD Pipeline failed. Please check the console log for errors.'
        }
    }
}
