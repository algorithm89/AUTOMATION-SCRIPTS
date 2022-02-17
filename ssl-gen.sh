
#!/bin/sh

dnf install easy-rsa
read -p "Username to use?: " user1

DIR=$(ls -la /home/$user1 | grep easy* |  cut -d " " -f 13)

echo $DIR
if [[ "$DIR" == "easy-rsa" ]];
then 
	echo "$DIR is present, or delete, or Proceed Manually "
	echo "Please Revoke Cert"
	echo "./easyrsa revoke CLIENTNAME"
else

mkdir /home/$user1/easy-rsa
ln -s /usr/share/easy-rsa/* /home/$user1/easy-rsa/
ls -la /home/$user1/easy-rsa
sudo chown -R devops:devops /home/$user1/easy-rsa

read -p "Please choose a version Above: " V1

chmod 700 /home/$user1/easy-rsa/$V1


fi

#----DEFAULT-CREATION-CA----#
cat << EOF > /home/$user1/easy-rsa/$V1/vars


set_var EASYRSA_REQ_COUNTRY    "CA"
set_var EASYRSA_REQ_PROVINCE   "MTL"
set_var EASYRSA_REQ_CITY       "QC"
set_var EASYRSA_REQ_ORG        "BublikStudios"
set_var EASYRSA_REQ_EMAIL      "bublik.studios@gmail.com"
set_var EASYRSA_REQ_OU         "BublikStudios"
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"


EOF
sudo chown -R devops:devops /home/$user1/$V1/easy-rsa

#----CA-GEN----#

cd /home/$user1/easy-rsa/$V1 && ./easyrsa init-pki
cd /home/$user1/easy-rsa/$V1 && ./easyrsa build-ca nopass
cat /home/$user1/easy-rsa/$V1/pki/ca.crt > /tmp/ca.crt



read -p "Distribution? : " VAR1


if [[ "$VAR1" = "centos"  ]] ||  [[ "$VAR1" = "fedora"  ]] || [[ "$VAR1" = "redhat"  ]];
then
        echo "Your OS is: " $VAR1
        echo "You have a Linux Distro with YUM or DNF"
	sudo cp /tmp/ca.crt /etc/pki/ca-trust/source/anchors/
        sudo update-ca-trust
elif [[ "$VAR1" = "ubuntu"  ]] ||  [[ "$VAR1" = "debian"  ]];
then
        echo "Your OS is:" $VAR1
        echo "You have a DEBIAN system... apt-get..."
	sudo cp /tmp/ca.crt /usr/local/share/ca-certificates/
        sudo update-ca-certificates

else
        echo "Don't recognize this DISTRO" $VAR1
fi

rm -rf /tmp/ca.crt

cat << EOF > ./san.cnf 
 [req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no




[req_distinguished_name]
countryName                = CA
stateOrProvinceName        = QC
localityName               = MTL
organizationName           = bubliks
organizationalUnitName     = bubliks
commonName                 = studios.bubliks.net



[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names



[alt_names]
DNS.1   = dns1.name1
DNS.2   = dns2.name1
DNS.3   = dns3.name1
DNS.4   = dns4.name1
DNS.5   = dns5.name1
DNS.6   = dns6.name1
DNS.7   = dns7.name1
DNS.8   = dns8.name1

EOF

sudo chown -R devops:devops ./san.cnf

#----CERT-GEN----#


read -p "Enter domain Name I.E gamespot.com: " DNSNAME
for I in {1..8}
do
read -p "Enter domain prefix I.E www in www.gamespot.com:  " dnsname

echo "DNS SUFFIX: $DNSNAME"
echo "DNS PREFIX $I: $dnsname"

sed -i "s/dns$I/$dnsname/g" ./san.cnf

done


sed -i "s/name1/$DNSNAME/g" ./san.cnf

openssl req -new -out ./bubliks.csr -newkey rsa:2048 -nodes -sha256 -keyout bubliks.key -config san.cnf
openssl req -text -noout -verify -in ./bubliks.csr

sudo chown -R devops:devops .*

#---SIGN-CSR---#

./easyrsa import-req bubliks.csr bubliks-server
./easyrsa sign-req server bubliks-server



