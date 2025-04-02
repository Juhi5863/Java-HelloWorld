pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'juhichoudhary/helloworld-java'
        DOCKER_TAG = 'latest'
        KUBE_DEPLOYMENT = 'helloworld-deployment'
        KUBE_NAMESPACE = 'default'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Juhi5863/Java-HelloWorld.git'           
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'c8e21db3-78da-47fc-8ad0-3f1c45043a02', url: '']) {
                    sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl set image deployment/$KUBE_DEPLOYMENT helloworld=$DOCKER_IMAGE:$DOCKER_TAG -n $KUBE_NAMESPACE'
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
