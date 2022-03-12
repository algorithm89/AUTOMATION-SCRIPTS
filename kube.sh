#!/bin/bash


#----Functions----#

function validateIP()
 {
         local ip=$1
         local stat=1
         if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                OIFS=$IFS
                IFS='.'
                ip=($ip)
                IFS=$OIFS
                [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
                && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
                stat=$?
        fi
        return $stat
}



#---Kubernetes---#

#--MASTER--#
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
modprobe br_netfilter

firewall-cmd --zone=internal --permanent --add-port={6443,2379,2380,10250,10251,10252}/tcp

modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

cat < /etc/sysctl.d / k8s.conf
net.bridge.bridge - nf - call - ip6tables = 1
net.bridge.bridge - nf - call - iptables = 1
EOF


sysctl --system
firewall-cmd --reload


cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


sudo dnf remove kubernetes* kubelet* -y
dnf upgrade -y
dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet
systemctl start kubelet

read -p "Please Enter WORKER IP: "   WORKIP
validateIP $WORKIP

firewall-cmd --zone=internal --permanent --add-rich-rule "rule family=ipv4 source address='$WORKIP'/32 accept"
firewall-cmd --zone=internal --permanent --add-rich-rule 'rule family=ipv4 source address=172.17.0.0/16 accept'

firewall-cmd --reload


read -p "Please Enter username: "    USER1
read -p "Please Enter MASTER IP: "   MASTERIP
validateIP $MASTERIP
kubeadm init --apiserver-advertise-address=$MASTERIP --v=5



mkdir -p /home/$USER1/.kube
cp -i /etc/kubernetes/admin.conf /home/$USER1/.kube/config
chown -R $USER1:$USER1 /home/$USER1/.kube/config
cd /home/$USER1 && chown -R $USER1:$USER1 .kube

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"



