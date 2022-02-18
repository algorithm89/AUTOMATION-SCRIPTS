
#!/bin/bash

rm -rf /var/lib/jenkins/security
mkdir /var/lib/jenkins/security

read -p "User you are using: " user1

ls -la /home/$user1/easy-rsa

read -p "easy-rsa version that you used?: " V1

cp /home/$user1/easy-rsa/$V1/*.key 	       /var/lib/jenkins/security
cp /home/$user1/easy-rsa/$V1/pki/issued/*.crt  /var/lib/jenkins/security
cp /home/$user1/easy-rsa/$V1/pki/ca.crt        /var/lib/jenkins/security

sudo chown -R jenkins:jenkins /var/lib/jenkins/security

echo "====NAME OF YOUR CERTS===="
echo "Use these names to generate your keystore!"


cd /var/lib/jenkins/security
ls -la 
read -p "Name of Certificate Authority just type ca and not ca.crt: " CA
read -p "Name of private key... just type the name: " KEY
read -p "Name of Public Cert... just the name: " PUB

echo "====CHECK FINGERPRINT MATCHING====="

sudo openssl x509 -in bubliks-server.crt -modulus -noout | openssl md5
sudo openssl rsa -in bubliks.key -modulus -noout | openssl md5


openssl pkcs12 -export -out jenkins.p12 \
-passout pass:toor89 -inkey $KEY.key \
-in $PUB.crt -certfile $CA.crt -name studio.bubliks.net

ls -la
sudo chown -R jenkins:jenkins /var/lib/jenkins/security

keytool -list -v -keystore jenkins.p12 -storepass toor89 \
    -storetype PKCS12


