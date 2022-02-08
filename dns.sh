#!/bin/bash


#--Install Bind Utils
sudo dnf  install bind -y && sudo dnf install bind-utils -y

sudo systemctl enable named
sudo systemctl start named
sudo status named





