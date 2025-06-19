#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "🔧 Installing Java 17 (Amazon Corretto)..."
sudo yum install -y java-17-amazon-corretto

echo "✅ Java version installed:"
java -version

echo "📦 Downloading Apache Maven 3.9.10..."
curl -O https://dlcdn.apache.org/maven/maven-3/3.9.10/binaries/apache-maven-3.9.10-bin.tar.gz

echo "📂 Extracting Maven..."
sudo tar -zxvf apache-maven-3.9.10-bin.tar.gz -C /opt/
sudo ln -s /opt/apache-maven-3.9.10 /opt/maven

echo "🔧 Setting Maven environment variables..."
sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export M2_HOME=/opt/maven
export PATH=\$M2_HOME/bin:\$PATH
EOF

sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

echo "✅ Maven version installed:"
mvn -version

echo "🌐 Downloading kubectl binary..."
KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"

echo "🔍 Verifying kubectl checksum..."
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

echo "📦 Installing kubectl to /usr/local/bin..."
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "✅ kubectl version installed:"
kubectl version --client
