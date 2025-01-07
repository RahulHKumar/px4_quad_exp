#!/bin/bash

sudo chmod -R o+r /var/lib/command-not-found/

# install net-tools
sudo apt-get update 
sudo apt-get upgrade
sudo apt-get install -y net-tools vim

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker

sudo usermod -aG docker $USER

newgrp docker

docker run hello-world


## setup github account
git config --global user.email "rahulhkumar9@gmail.com"
git config --global user.name "RahulHKumar"

ssh-keygen -t ed25519 -C "rahulhkumar9@gmail.com"
eval "$(ssh-agent -s)"


cat ~/.ssh/id_ed25519.pub
