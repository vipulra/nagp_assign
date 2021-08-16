pipeline {
    environment {
        username = 'vipulrastogi'
        registry = 'vipul7/nagp_assign'
 
    }
    
    agent any
    
    tools {
        maven "maven"
    }

    stages {
        stage('Build') {
            steps {
//                 
                
                bat "mvn clean install"
            }
        }
    
    
    stage('Unit Testing') {
        steps {
            bat "mvn test"
        }
    }
    
    stage('Sonar Analysis') {
        environment {
            scannerHome = tool name: 'SonarQubeScanner'
        }
        
        steps {
            withSonarQubeEnv("Test_Sonar") {
                bat "mvn clean package sonar:sonar"
            }
        }
    }
    
    stage('Docker Image') {
        steps {
            bat "docker build -t i-${username}-feature:${BUILD_NUMBER} --no-cache -f Dockerfile ."
        }
    }
    
    stage('Push image to docker hub') {
        steps {
            bat "docker tag i-${username}-feature:${BUILD_NUMBER} ${registery}:${BUILD_NUMBER}"
            bat "docker tag i-${username}-feature:${BUILD_NUMBER} ${registery}:latest"
            withDockerRegistery([credentialsId: 'Test_Docker', url: ""]) {
                bat "docker push ${registry}:${BUILD_NUMBER}"
                bat "docker push ${registry}:latest"
            }
        }
    }
    
    stage('Deployment') {
        parallel {
            stage('deployment docker container') {
                steps {
                    script {
                        try {
                            bat "docker rm -f c-{username}-feature"
                        }
                        catch (Exception err) {
                            
                        }
                        bat "docker run --name c-${username}-feature -d -p 7400:8080 ${registry}:latest"
                    }
                }
            }
            
            stage('Deploy to GKE') {
                steps {
                    bat "kubectl apply -f deployment.yaml"
                }
            }
        }
    }
    }
    
    
}
