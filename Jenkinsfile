stage('Deploy Docker App to Remote Host') {
  when {
    expression { params.ACTION == 'create' }
  }
  steps {
    script {
      sh """
        echo "📦 Copying app code to Docker host (${REMOTE_HOST})..."
        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} 'rm -rf ${REMOTE_DIR}'
        scp -o StrictHostKeyChecking=no -r app/ ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}

        echo "🐳 Building and running Docker container remotely..."
        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} <<EOF
          cd ${REMOTE_DIR}
          docker stop ${CONTAINER_NAME} || true
          docker rm ${CONTAINER_NAME} || true
          docker build -t ${IMAGE_NAME} .
          docker run -d -p 3000:3000 --name ${CONTAINER_NAME} ${IMAGE_NAME}
EOF
      """
    }
  }
}
