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
            echo "RKE2 cluster'ına deployment yapılıyor..."
            sh """
                export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
                kubectl apply -f k8s/cluster-issuer.yaml
                kubectl apply -f k8s/ingress.yaml
                kubectl apply -f nginx-deployment.yaml
                kubectl rollout status deployment/django-ngin
            """
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
