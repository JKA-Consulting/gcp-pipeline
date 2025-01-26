pipeline {
    agent any
    environment {
                PROJECT_ID = "$PROJECT_ID"
                TF_STATE_BUCKET_NAME = "$TF_STATE_BUCKET_NAME"
    }
    stages {
        stage('terraform init and apply') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'google-auth-file', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}'
                        sh 'terraform init -backend-config="bucket=${TF_STATE_BUCKET_NAME}" -backend-config="prefix=terraform/state"'
                        sh 'terraform apply --auto-approve -var="project-id=${PROJECT_ID}"'
                    }
                }
            }
        }
        stage('terraform action') {
            input {
                message "select action"
                ok "Done"
                parameters{
                    choice(name: 'ACTION', choices: ['output', 'destroy'], description: 'to choose the next choice of action')
                }
            }
            steps {
                script {
                    echo "Terraform action is -> ${params.ACTION}"
                    sh "terraform ${params.ACTION} --auto-approve"
                }
            }
        }
    }
}
