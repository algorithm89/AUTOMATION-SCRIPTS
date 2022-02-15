#!/bin/bash


#----Install Bind Utils----#
sudo dnf  install bind -y && sudo dnf install bind-utils -y



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





TTL=$(echo \$TTL)


#----Build-Forward-Zone----#


read -p "Please name your FORWARD zone DNS file: " VAR1

if [ -z "$VAR1" ]
then
        echo "Please Name your File..."
else
cat << EOF > /var/named/forward.$VAR1

$TTL 86400
@   IN  SOA     example.net. root.example.local. (
        2011071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
@       IN  NS          example1.
@       IN  NS          example2.
@       IN  A           DNSIP1
@       IN  A           DNSIP2
@       IN  A           DNSIP3

@               IN  A   DNSIP1
@               IN  A   DNSIP2
@               IN  A   DNSIP3
example11       IN  A   DNSIP1
example21       IN  A   DNSIP2

DNS1            IN  A   DNSIP1
DNS2            IN  A   DNSIP2
DNS3            IN  A   DNSIP1
DNS4            IN  A   DNSIP2
DNS5            IN  A   DNSIP3

EOF


read -p "Choose FQDN-I.E: cool.bobba.net: " VAR22
read -p "Choose NameServer1  FQDN I.E ns1.cool.net: " VAR2
read -p "Choose NameServer2  FQDN I.E ns2.cool.net: " VAR3
sed -i "s/example[0-1]\./$VAR2\./g" /var/named/forward.$VAR1
sed -i "s/example[2-3]\./$VAR3\./g" /var/named/forward.$VAR1

ns1=$(echo $VAR2 | cut -d"." -f 1)
ns2=$(echo $VAR3 | cut -d"." -f 1)

sed -i "s/example11/$ns1/g" /var/named/forward.$VAR1
sed -i "s/example21/$ns2/g" /var/named/forward.$VAR1
sed -i "s/example\.net/$VAR22/g"    /var/named/forward.$VAR1

VAR41=$(echo $VAR22  | cut -d"." -f 2,3)
sed -i "s/root\.example\.local/root\.$VAR41/g" /var/named/forward.$VAR1



echo "Enter IP Address for your FQDN: "
read IPADDR
validateIP $IPADDR

if [[ $? -ne 0 ]];then
  echo "Invalid IP Address ($IPADDR)"
else
  echo "$IPADDR is a VAR4=$(echo $VAR22  | cut -d"." -f 2,3)
echo $VAR4Perfect IP Address"
for num in {1..3}
	do
	echo "DNSIP$num"
	sed -i "s/DNSIP$num/$IPADDR/g" /var/named/forward.$VAR1
done
fi


VAR4=$(echo $VAR22  | cut -d"." -f 2,3)
echo $VAR4



for var in {1..5}
do
read -p "ENTER DNS FIRST NAME OF DNS ONLY I.E www.gamespot.com, write WWW ONLY: " DNSNAME

if [ -z $DNSNAME ]
then
        echo "Please Enter a FQDN..."
else
 echo "DNS$var has been added..."
 sed -i "s/DNS$var/$DNSNAME/g" /var/named/forward.$VAR1
fi
done


fi



#----Build-Reverse-Zone----#

echo "Your IP is: " $IPADDR
IFS=. ; set -- $IPADDR
ENDIP=$(echo $IPADDR | cut -d " " -f 4)


TTL=$(echo \$TTL)

read -p "Please name your REVERSE DNS file: " VAR1

if [ -z "$VAR1" ]
then
        echo "Please Name your REVERSE File..."
else
cat << EOF > /var/named/reverse.$VAR1

$TTL 86400
@   IN  SOA     example1.net. root.example.local (
        2011071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
@       IN  NS          example.awsome.net1.
@       IN  NS          example.awsome.net2.
@       IN  PTR         awsome.net.
ns1                IN  A   FULLIP1
ns2                IN  A   FULLIP2
STARTDNS1          IN  A   FULLIP3
STARTDNS2          IN  A   FULLIP4
STARTDNS3          IN  A   FULLIP5
STARTDNS4          IN  A   FULLIP6
STARTDNS5          IN  A   FULLIP7
ENDIP1     IN  PTR         DNSNAME1.
ENDIP2     IN  PTR         DNSNAME2.
ENDIP3     IN  PTR         DNSNAME3.
ENDIP4     IN  PTR         DNSNAME4.
ENDIP5     IN  PTR         DNSNAME5.

EOF



read -p "Choose FQDN-I.E: cool.bobba.net: " VAR22
sed -i "s/example\.awsome.net1\./$VAR2\./g" /var/named/reverse.$VAR1
sed -i "s/example\.awsome.net2\./$VAR3\./g" /var/named/reverse.$VAR1
sed -i "s/example1\.net/$VAR22/g"    /var/named/reverse.$VAR1
sed -i "s/root\.example\.local/root\.$VAR4/g" /var/named/reverse.$VAR1
sed -i "s/awsome\.net/$VAR4/g" /var/named/reverse.$VAR1

sed -i "s/ns1/$VAR2/g" /var/named/reverse.$VAR1
sed -i "s/ns2/$VAR3/g" /var/named/reverse.$VAR1

for num in {1..7}
        do
        echo "DNSIP$num have been added"
        sed -i "s/FULLIP$num/$IPADDR/g" /var/named/reverse.$VAR1

done



for var in {1..5}
do
read -p "ENTER DNS FIRST NAME OF DNS ONLY I.E www.gamespot.com, write WWW ONLY: " DNSNAME

if [ -z $DNSNAME ]
then
        echo "Please Enter a FQDN..."
else

 echo "DNSNAME$var has been added..."
 sed -i "s/DNSNAME$var/$DNSNAME.$VAR4/g" /var/named/reverse.$VAR1

 echo "STARTDNS$var has been added..."
 sed -i "s/STARTDNS$var/$DNSNAME/g" /var/named/reverse.$VAR1

 fi
done


for num2 in {1..5}
do
	echo "ENDIP$num2 has been added"
	sed -i "s/ENDIP$num2/$ENDIP/g" /var/named/reverse.$VAR1
done

fi


VAR4=$(echo $VAR22  | cut -d"." -f 2,3)
echo $VAR4

read -p "Put your Internal Interface: " INT

firewall-cmd --change-interface=$INT --zone=internal --permanent
firewall-cmd --permanent --add-port=53/tcp --zone=internal --permanent
firewall-cmd --permanent --add-port=53/udp --zone=internal --permanent
firewall-cmd --reload

chgrp named -R /var/named
chown -v root:named /etc/named.conf
restorecon -rv /var/named
restorecon /etc/named.conf

read -p "ENTER THE DNS NAME WITHOUTH THE FIRST i.e gamespot.com: " VAR55


named-checkconf /etc/named.conf

named-checkzone $VAR55  /var/named/forward.$VAR1
named-checkzone $VAR55  /var/named/reverse.$VAR1


#----RESOLVER----#

VAR44=$(echo $VAR22  | cut -d"." -f 2,3)
echo $VAR44

chattr -i /etc/resolv.conf

cat << EOF > /etc/resolv.conf

# Generated by NetworkManager
search home DNSNAMESERVER
nameserver DNSIP1
nameserver ROUTERIP

EOF

read -p "ENTER IP INTERNAL: " IP1
read -p "ENTER IP OF HOUSE DEFAULT GATEWAY: " IP2 


sed -i "s/DNSNAMESERVER/$VAR55/g"  /etc/resolv.conf
sed -i "s/DNSIP1/$IP1/g"          /etc/resolv.conf
sed -i "s/ROUTERIP/$IP2/g"        /etc/resolv.conf


chattr +i /etc/resolv.conf
systemctl restart named
nslookup $VAR55


