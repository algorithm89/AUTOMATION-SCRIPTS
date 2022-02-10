#!/bin/bash

#---Docker---#
sudo dnf remove docker docker-latest docker-engine docker-client docker-common docker-client-latest docker-logrotate docker-latest-logrotate
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo


#---Kubernetes---#

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
modprobe br_netfilter


firewall-cmd --zone=internal --permanent --add-port={6443,2379,2380,10250,10251,10252}/tcp

