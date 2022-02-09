#!/bin/sh

#---Install-Python---#
sudo dnf install wget yum-utils make gcc openssl-devel bzip2-devel libffi-devel zlib-devel 
sudo rm -rf /opt/Pyth*
cd /opt && sudo wget https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz
VAR=$(ls -la | grep Pyth* | awk '{print $9}' | cut -d"-" -f 2)
sudo tar -xvzf /opt/Python-$VAR
VAR2=$(echo "Python-$VAR" | sed 's/\.tgz/''/g')
cd /opt/$VAR2 && ./configure --with-system-ffi --with-computed-gotos --enable-loadable-sqlite-extensions 
cd /opt/$VAR2 && sudo make -j ${nproc} 
cd /opt/$VAR2 && sudo make altinstall 

sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.9 2
python3 -V  

#---Instal-Java---#

sudo dnf install java-17-openjdk-devel
java -version

#---Install-Jenkins---#
# sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
# sudo dnf install jenkins
# sudo systemctl start jenkins
# sudo systemctl enable jenkins
# sudo firewall-cmd --permanent --zone=internal --add-port=8080/tcp
# sudo firewall-cmd --reload

