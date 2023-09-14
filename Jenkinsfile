@Library('jenkins-shared-library@develop') _

def imageName = "petclinic-image"
def versionTag = "1.0"

pipeline {
    agent {
        label 'AGENT-01'
    }

    stages {
        stage('Lint Dockerfile') {
            steps {
                hadoLint()
            }
        }
        stage('Build Docker Image') {
            agent {
                docker {
                    image '814200988517.dkr.ecr.us-west-2.amazonaws.com/docker-images:base-image'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --privileged '
                    reuseNode true
                }
            }
            environment {
                DOCKER_CONFIG = '/tmp/docker'
            }
            steps {
                script {
                    try {
                        dockerBuild(
                            versionTag: versionTag,
                            imageName: imageName
                        )
                    } catch (Exception buildError) {
                        currentBuild.result = 'FAILURE'
                        error("Failed to build Docker image: ${buildError}")
                    }
                }
            }
        }
        stage('Run Trivy Scan') {
            steps {
                script {
                    try {
                        def imageNameAndTag = "${imageName}:${versionTag}"
                        trivyScan(imageNameAndTag)
                    } catch (Exception trivyError) {
                        currentBuild.result = 'FAILURE'
                        error("Trivy scan failed: ${trivyError}")
                    }
                }
            }
        }
        stage('Send Trivy Report') {
            steps {
                script {
                    try {
                        def imageNameAndTag = "${imageName}:${versionTag}"
                        def reportPath = "trivy-report.html"
                        def recipient = "aswin@crunchops.com"
                        emailReport(reportPath, imageNameAndTag, recipient)
                    } catch (Exception emailError) {
                        currentBuild.result = 'FAILURE'
                        error("Email Send failed: ${emailError}")
                    }
                }
            }
        }
        stage('Slim Docker Image') {
            when {
                expression { true }
            }
            steps {
                script {
                    try {
                        def imageNameAndTag = "${imageName}:${versionTag}"
                        slimImage.slimImage(imageNameAndTag)
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("Failed to slim Docker image: ${e.message}")
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                emailNotification.sendEmailNotification('success', 'aswin@crunchops.com')
            }
        }
        failure {
            script {
                emailNotification.sendEmailNotification('failure', 'aswin@crunchops.com')
            }
        }
        always {
            cleanWs()
        }
    }
}
