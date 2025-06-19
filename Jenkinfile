pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['create', 'destroy'], description: 'Select the Terraform action to perform')
  }

  environment {
    AWS_DEFAULT_REGION = 'ap-south-1'
  }

  options {
    timestamps()
  }

  stages {
    stage('Checkout Code') {
      steps {
        git branch: 'main', url: 'https://github.com/nenavathsrinu/Real-Time-DevOps-Hands-On-Project-Plan.git'
      }
    }

    stage('Terraform Action') {
      steps {
        dir('terraform') {
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-credentials'
          ]]) {
            script {
              if (params.ACTION == 'create') {
                sh '''
                  terraform init
                  terraform validate
                  terraform plan -out=tfplan
                  terraform apply -auto-approve tfplan
                '''
              } else if (params.ACTION == 'destroy') {
                sh '''
                  terraform init
                  terraform validate
                  terraform destroy -auto-approve
                '''
              } else {
                error "Unsupported ACTION value: ${params.ACTION}"
              }
            }
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ Terraform '${params.ACTION}' completed successfully!"
    }
    failure {
      echo "❌ Terraform '${params.ACTION}' failed."
    }
  }
}
