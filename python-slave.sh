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
java -version

sudo tee /etc/profile.d/java11.sh <<EOF

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=\$PATH:\$JAVA_HOME/bin

EOF
source /etc/profile.d/java11.sh
echo $JAVA_HOME

update-alternatives --config java
java --version
