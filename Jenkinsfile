pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'juhichoudhary/helloworld-java'
        DOCKER_TAG = 'latest'
        KUBE_DEPLOYMENT = 'helloworld-deployment'
        KUBE_NAMESPACE = 'default'
        KUBECONFIG = '/var/lib/jenkins/.kube/config'  // Ensure Jenkins can access Kubernetes
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Juhi5863/Java-HelloWorld.git'           
            }
        }

        stage('Fix System Time') {
            steps {
                sh '''
                    sudo timedatectl set-ntp off
                    sudo timedatectl set-ntp on
                    date
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build --no-cache -t $DOCKER_IMAGE:$DOCKER_TAG .' // Avoid caching issues
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: '6a280542-7619-4c87-9db0-a1208d2b1bc5', url: '']) {
                    sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube
                    sudo chmod 600 /var/lib/jenkins/.kube/config
                    export KUBECONFIG=/var/lib/jenkins/.kube/config
                    kubectl config view
                    kubectl set image deployment/$KUBE_DEPLOYMENT helloworld=$DOCKER_IMAGE:$DOCKER_TAG -n $KUBE_NAMESPACE
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
