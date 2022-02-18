
#!/bin/sh

rm -rf   /usr/local/apache-maven/
mkdir  -p /usr/local/apache-maven/apache-maven-3.8.4
cd       /usr/local/apache-maven/apache-maven-3.8.4

curl -O https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz

tar -xvf apache-maven-3.8.4-bin.tar.gz -C /usr/local/apache-maven/apache-maven-3.8.4

mv /usr/local/apache-maven/apache-maven-3.8.4/apache-maven-3.8.4/* /usr/local/apache-maven/apache-maven-3.8.4/
rm -rf /usr/local/apache-maven/apache-maven-3.8.4/apache-maven-3.8.4

export M2_HOME=/usr/local/apache-maven/apache-maven-3.8.4
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

mvn -version
