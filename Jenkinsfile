
pipeline {
    agent any
    
    stages {
        // Verifying setup
        stage('Confirm Tools Installations') {
            steps {
                sh 'git --version'
                sh 'terraform version'
                sh 'checkov --version'
            }
        }
        // IInitialize Terraform
        stage('Initialize Terraform Environment') {
            steps {
                sh 'terraform init'
            }
        }
        // Check terraform confugirations syntax
        stage('Validate Terraform Configurations') {
            steps {
                sh 'terraform validate'
               
            }
        }
        // Generating Execution Plan
        stage('Generate Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        // // Checkov Infrastructure Automation Test
        // stage('Checkov scan') {
        //     steps {
        //         sh 'checkov -d .'
        //     }
        // }
        // Deployment Apporval
        stage('Manual Approval') {
            steps {
                input 'Approval Infra Deployment'
            }
        }
        // Deploy Terraform Infrastructure
        stage('Deploy Infrastructure') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
        // Destroy Environment
        // stage('Terraform Destroy') {
        //     steps {
        //         sh 'terraform destroy --var-file=prod.tfvars --auto-approve'
        //     }
        // }
    }
   
}