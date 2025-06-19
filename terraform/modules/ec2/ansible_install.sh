#!/bin/bash

# Update packages
sudo yum update -y

# Install Java 17 (Amazon Corretto)
sudo yum install -y java-17-amazon-corretto

# Verify Java
java -version

# Add Jenkins repo
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install dependencies
sudo yum install -y git fontconfig jenkins

# Enable Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Status
sudo systemctl status jenkins
