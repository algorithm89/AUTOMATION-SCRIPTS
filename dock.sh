#!/bin/sh

#---Docker---#

read -p "your username please: " USER1

sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc
sudo yum remove docker* -y

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io


sudo groupadd docker
sudo usermod -aG docker $USER1

sudo systemctl  enable docker
sudo systemctl restart docker


sudo systemctl reset-failed docker.service
sudo systemctl restart docker



