pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'juhichoudhary/helloworld-java'
        DOCKER_TAG = 'latest'
        KUBE_DEPLOYMENT = 'helloworld-deployment'
        KUBE_NAMESPACE = 'default'
        KUBECONFIG = '/var/lib/jenkins/.kube/config' // Recommend this over deep .minikube paths
        PATH+EXTRA = '/usr/local/bin' // Helps find docker, kubectl if installed here
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Juhi5863/Java-HelloWorld.git'           
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "🔨 Building Docker image..."
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: '6a280542-7619-4c87-9db0-a1208d2b1bc5', url: '']) {
                    sh '''
                        echo "📤 Pushing Docker image to DockerHub..."
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    echo "🚀 Deploying to Kubernetes..."
                    export KUBECONFIG=${KUBECONFIG}
                    
                    echo "🔍 Getting pods in namespace ${KUBE_NAMESPACE}..."
                    kubectl get pods -n ${KUBE_NAMESPACE}
                    
                    echo "📦 Updating deployment ${KUBE_DEPLOYMENT} with new image..."
                    kubectl set image deployment/${KUBE_DEPLOYMENT} helloworld=${DOCKER_IMAGE}:${DOCKER_TAG} -n ${KUBE_NAMESPACE}
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}




pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'juhichoudhary/java-application:${BUILD_NUMBER}' // Unique versioned image
        DOCKER_CREDENTIALS = '6a280542-7619-4c87-9db0-a1208d2b1bc5' // Jenkins Docker Hub Credentials ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/Juhi5863/Java-HelloWorld.git'
                }
            }
        }

        stage('Build with Maven') {
            
            steps {
                script {
                    sh 'mvn clean package -DskipTests=true'
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
