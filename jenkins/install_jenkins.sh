#!/bin/bash

# Update package list and install dependencies
sudo apt update
sudo apt install -y openjdk-11-jdk

# Add Jenkins repository and install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \   /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check if Jenkins started successfully
if sudo systemctl status jenkins | grep -q "active (running)"; then
    echo "Jenkins started successfully."
else
    echo "Failed to start Jenkins. Checking logs..."
    sudo journalctl -u jenkins -n 50
    exit 1
fi

# Install Docker and add Jenkins to the Docker group
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker jenkins
sudo usermod -aG docker 

# Restart Jenkins to apply group changes
sudo systemctl restart jenkins

# Check if Jenkins restarted successfully
if sudo systemctl status jenkins | grep -q "active (running)"; then
    echo "Jenkins restarted successfully."
else
    echo "Failed to restart Jenkins. Checking logs..."
    sudo journalctl -u jenkins -n 50
    exit 1
fi

# Install Git
sudo apt install -y git
