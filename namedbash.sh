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



cat << EOF > /etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
    listen-on port 53 { 127.0.0.1; IP1;}; ### Master DNS IP ###
#    listen-on-v6 port 53 { ::1; };
    directory     "/var/named";
    dump-file     "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    allow-query     { localhost; IPRANGE/24;}; ### IP Range ###
    allow-transfer{ localhost; IPSLAVE; };   ### Slave DNS IP ###

    /*
     - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
     - If you are building a RECURSIVE (caching) DNS server, you need to enable
       recursion.
     - If your recursive DNS server has a public IP address, you MUST enable access
       control to limit queries to your legitimate users. Failing to do so will
       cause your server to become part of large scale DNS amplification
       attacks. Implementing BCP38 within your network would greatly
       reduce such attack surface
    */
    recursion yes;

    dnssec-enable yes;
    dnssec-validation yes;
    dnssec-lookaside auto;

    /* Path to ISC DLV key */
    bindkeys-file "/etc/named.iscdlv.key";

    managed-keys-directory "/var/named/dynamic";

    pid-file "/run/named/named.pid";
    session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
    type hint;
    file "named.ca";
};

zone "DNSNAME" IN {
type master;
file "forward.VAR1";
allow-update { none; };
};
zone "REV1.REV2.REV3.in-addr.arpa" IN {
type master;
file "reverse.VAR1";
allow-update { none; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

read -p "Enter IP for your DNS: " IP1
validateIP $IP1

read -p "Enter dns name but only this part I.E gamespot.com: " DNSNAME
echo "Your IP is: " $IP1
IFS=. ; set -- $IP1

REVIP1=$(echo $IP1 | cut -d " " -f 4)
REVIP2=$(echo $IP1 | cut -d " " -f 2)
REVIP3=$(echo $IP1 | cut -d " " -f 1)




read -p "Please Enter IP range I.E 192.168.1.0: "   IPRANGE
validateIP $IPRANGE


read -p "Please Enter Slave IP: "   IPSLAVE
validateIP $IPSLAVE

sed -i "s/IP1/$IP1/g" /etc/named.conf
sed -i "s/IPRANGE/$IPRANGE/g" /etc/named.conf
sed -i "s/IPSLAVE/$IPSLAVE/g" /etc/named.conf



sed -i "s/DNSNAME/$DNSNAME/g" /etc/named.conf
NAME1=$(echo "$DNSNAME"  | sed "s/\.net//g")

sed -i "s/VAR1/$NAME1/g"   /etc/named.conf
sed -i "s/REV2/$REVIP2/g" /etc/named.conf
sed -i "s/REV3/$REVIP3/g" /etc/named.conf
sed -i "s/REV1/$REVIP1/g" /etc/named.conf





