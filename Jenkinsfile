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
