pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'juhichoudhary/java-application:${BUILD_NUMBER}' // Unique versioned image
        DOCKER_CREDENTIALS = '6a280542-7619-4c87-9db0-a1208d2b1bc5' // Jenkins Docker Hub Credentials ID
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/Juhi5863/Java-HelloWorld.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        sh "docker push ${DOCKER_IMAGE}"
                        sh "docker logout"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh "kubectl apply -f deployment.yaml"
                        sh "kubectl apply -f service.yaml"
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed! Check the logs for details."
        }
        success {
            echo "Deployment successful! 🚀"
        }
    }
}
