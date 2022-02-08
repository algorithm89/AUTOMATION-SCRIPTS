#!/bin/bash


#----Install Bind Utils----#
sudo dnf  install bind -y && sudo dnf install bind-utils -y

sudo systemctl enable named
sudo systemctl start named
sudo systemctl status named



#----Build-Forward-Zone----#


read -p "Please name your DNS file: " VAR1

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
DNS1            IN  A   DNSIP1
DNS2            IN  A   DNSIP2
DNS3            IN  A   DNSIP1
DNS4            IN  A   DNSIP2
DNS5            IN  A   DNSIP3

EOF

read -p "Choose FQDN-I.E: cool.bobba.net: " VAR22
read -p "Choose DNS name-NOT FQDN I.E cool.net:" VAR2
sed -i "s/example[0-3]\./$VAR2\./g" /var/named/forward.$VAR1
sed -i "s/example[0-3]\./$VAR2\./g" /var/named/forward.$VAR1
sed -i "s/example\.net/$VAR22/g"    /var/named/forward.$VAR1
sed -i "s/root\.example\.local/root\.$VAR2/g" /var/named/forward.$VAR1

read -p "Please Enter 1 IP for your ZONE: " IPADDR
re='^[0-9]+$'

if ! [[ $IPADDR =~ $re ]] ;
then
   echo "error: Not a number" >&2; 
   exit 1
else

for num in {1..3}
do
echo "DNSIP$num"
sed -i "s/DNSIP$num/$IPADDR/g" /var/named/forward.$VAR1
done

fi

for var in {1..5}
do
read -p "ENTER DNS NAME: " DNSNAME

if [ -z $DNSNAME ]
then
        echo "Please Enter a FQDN..."
else
 echo DNS$var
 sed -i "s/DNS$var/$DNSNAME/g" /var/named/forward.$VAR1
fi
done


fi



#------Reverse-Zone-----#


