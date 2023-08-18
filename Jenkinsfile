pipeline {
    agent {
        node {
            label 'AGENT-01'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm 
            }
        }

        stage('Run Shell Script') {
            steps {
                sh '''#!/bin/bash
                echo "This runs for all branches."
                '''
            }
        }

        stage('Main Branch Specific Steps') {
            when {
                branch 'main'
            }
            steps {
                sh '''#!/bin/bash
                echo "This runs only for the main branch."
                # Add your main branch specific steps here.
                '''
            }
        }
    }

    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'Run succeeded!'
        }
        failure {
            echo 'Something went wrong!'
        }
    }
}

