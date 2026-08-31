pipeline {
    agent any

    environment {
        REGISTRY = "selingunaydin/django-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                    echo "İmaj build ediliyor: ${REGISTRY}:${IMAGE_TAG}"
                    sh "docker build -t ${REGISTRY}:${IMAGE_TAG} -t ${REGISTRY}:latest ."
                    
                    echo "İmajlar Docker Hub'a gönderiliyor..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo \$DOCKER_PASS | docker login -u selingunaydin --password-stdin"
                        
                        sh "docker push ${REGISTRY}:${IMAGE_TAG}"
                        sh "docker push ${REGISTRY}:latest"
                        
                        sh "docker logout"
                    }
                }
            }
        }

        stage('Deploy to RKE2 Cluster') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'k8s-kubeconfig']) {
                        sh "kubectl apply -f k8s/cluster-issuer.yaml"
                        sh "kubectl apply -f k8s/ingress.yaml"
                        sh "kubectl apply -f nginx-deployment.yaml"
                        sh "kubectl rollout status deployment/django-nginx-deployment --timeout=60s"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment RKE2 cluster üzerinde başarıyla tamamlandı!'
        }
        failure {
            echo 'Deployment sırasında bir hata oluştu.'
        }
    }
}
