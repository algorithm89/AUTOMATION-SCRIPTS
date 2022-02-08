

#!/bin/sh

read -p "Please name your DNS file: " VAR1 

if [ -z "$VAR1" ]
then
	echo "Please Name your File..."
else
cat << EOF > forward.$VAR1 

$TTL 86400
@   IN  SOA     . root.unixmen.local. (
        2011071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
@       IN  NS          example1.
@       IN  NS          example2.
@       IN  A           NSIP1
@       IN  A           NSIP2
@       IN  A           NSIP3
DNS1	        IN  A   DNSIP1
DNS2            IN  A   DNSIP2
DNS3            IN  A   DNSIP2
DNS4            IN  A   192.168.1.7
DNS5            IN  A   192.168.1.8
DNS6            IN  A   192.168.1.9

EOF

read -p "Choose DNS name:" VAR2
sed -e "s/masterdns\./$VAR2\./g" forward.$VAR1 


fi

#------Reverse-Zone-----#

if [ -z "$VAR4"  ]
then
	echo

fi


