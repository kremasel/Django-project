pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        IMAGE_NAME = 'selingunaydin/django-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Image') {
            steps {
                script {
                    def buildNumber = env.BUILD_NUMBER
                    echo "İmaj build ediliyor: ${IMAGE_NAME}:${buildNumber}"

                    sh "docker build -t ${IMAGE_NAME}:${buildNumber} -t ${IMAGE_NAME}:latest ."

                    echo "İmajlar Docker Hub'a gönderiliyor..."
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: "DOCKER_USER", passwordVariable: "DOCKER_PASS")]) {
                        sh "echo '${DOCKER_PASS}' | docker login -u '${DOCKER_USER}' --password-stdin"
                        sh "docker push ${IMAGE_NAME}:${buildNumber}"
                        sh "docker push ${IMAGE_NAME}:latest"
                        sh "docker logout"
                    }
                }
            }
        }

        stage('Deploy to RKE2 Cluster') {
            steps {
                script {
                    echo "RKE2 cluster'ına deployment yapılıyor..."
                    sh """
                        export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
                        kubectl apply --validate=false -f k8s/cluster-issuer.yaml
                        kubectl apply --validate=false -f k8s/ingress.yaml
                        kubectl apply --validate=false -f nginx-deployment.yaml
                        kubectl rollout status deployment/django-ngin
                    """
                }
            }
        }
    }

    post {
        failure {
            echo "Deployment sırasında bir hata oluştu."
        }
    }
}
