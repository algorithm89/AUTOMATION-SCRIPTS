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

sudo yum -y install  java-11-openjdk java-11-openjdk-devel

sudo tee /etc/profile.d/java11.sh <<EOF

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=\$PATH:\$JAVA_HOME/bin

EOF
source /etc/profile.d/java11.sh
echo $JAVA_HOME

#---Install-Jenkins---#
sudo yum remove jenkins -y

cat << EOF > /etc/yum.repos.d/jenkins.repo
 
[jenkins]

name=Jenkins-stable

baseurl=http://pkg.jenkins.io/redhat

gpgcheck=1

EOF
echo "CHOOSE JAVA 11 or 8, NOT 17!"

 update-alternatives --config java

 sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key


 sudo dnf install jenkins
 java --version
 sudo systemctl enable jenkins
 sudo systemctl restart jenkins
 sudo firewall-cmd --permanent --zone=internal --add-port=8080/tcp
 sudo firewall-cmd --reload
 

