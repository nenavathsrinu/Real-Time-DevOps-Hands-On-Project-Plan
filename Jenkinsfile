pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['create', 'destroy'], description: 'Choose action to perform')
  }

  environment {
    REMOTE_HOST = "15.206.28.137"
    REMOTE_USER = "ec2-user"
    APP_DIR = "nodejs-ip"
  }

  stages {
    stage('Deploy Docker App to Remote Host') {
      when {
        expression { params.ACTION == 'create' }
      }
      steps {
        script {
          echo "📦 Copying app code to Docker host (${env.REMOTE_HOST})..."

          sh """
            ssh -o StrictHostKeyChecking=no ${env.REMOTE_USER}@${env.REMOTE_HOST} 'rm -rf /home/${env.REMOTE_USER}/${env.APP_DIR}'
            scp -o StrictHostKeyChecking=no -r app/ ${env.REMOTE_USER}@${env.REMOTE_HOST}:/home/${env.REMOTE_USER}/${env.APP_DIR}
            ssh -o StrictHostKeyChecking=no ${env.REMOTE_USER}@${env.REMOTE_HOST} <<EOF
              cd /home/${env.REMOTE_USER}/${env.APP_DIR}
              docker stop my-node-app || true
              docker rm my-node-app || true
              docker build -t my-node-app .
              docker run -d -p 3000:3000 --name my-node-app my-node-app
            EOF
          """
        }
      }
    }

    stage('Destroy Docker Container') {
      when {
        expression { params.ACTION == 'destroy' }
      }
      steps {
        script {
          echo "🧹 Stopping and removing Docker container from ${env.REMOTE_HOST}..."

          sh """
            ssh -o StrictHostKeyChecking=no ${env.REMOTE_USER}@${env.REMOTE_HOST} <<EOF
              docker stop my-node-app || true
              docker rm my-node-app || true
            EOF
          """
        }
      }
    }
  }
}