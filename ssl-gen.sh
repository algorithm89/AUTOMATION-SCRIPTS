
#!/bin/sh

dnf install easy-rsa
read -p "Username to use?: " user1

mkdir /home/$user1/easy-rsa

ln -s /usr/share/easy-rsa/* /home/$user1/easy-rsa/
chmod 700 /home/$user1/easy-rsa


#----DEFAULT-CREATION-CA----#
cat << EOF > /home/$user1/easy-rsa/vars


set_var EASYRSA_REQ_COUNTRY    "CA"
set_var EASYRSA_REQ_PROVINCE   "MTL"
set_var EASYRSA_REQ_CITY       "QC"
set_var EASYRSA_REQ_ORG        "BublikStudios"
set_var EASYRSA_REQ_EMAIL      "bublik.studios@gmail.com"
set_var EASYRSA_REQ_OU         "BublikStudios"
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"


EOF


cd /home/$user1/easy-rsa && ./easyrsa build-ca nopass
cat /home/$user1/easy-rsa/pki/ca.crt > /tmp/ca.crt



read -p "Distribution? : " VAR1


if [[ "$VAR1" = "centos"  ]] ||  [[ "$VAR1" = "fedora"  ]] || [[ "$VAR1" = "redhat"  ]];
then
        echo "Your OS is: " $VAR1
        echo "You have a Linxu Distro with YUM or DNF"
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

EOF

#----CA-GEN----#


#----CERT-GEN----#


read -p "Enter domain Name I.E gamespot.com: " DNSNAME
for I in {1..6}
do
read -p "Enter domain prefix I.E www in www.gamespot.com:  " dnsname

echo "DNS SUFFIX: $DNSNAME"
echo "DNS PREFIX $I: $dnsname"

sed -i "s/dns$I/$dnsname/g" ./san.cnf

done


sed -i "s/name1/$DNSNAME/g" ./san.cnf



