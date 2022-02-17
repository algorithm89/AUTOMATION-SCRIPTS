
#!/bin/bash



read -p "Distribution? : " VAR1


if [[ "$VAR1" = "centos"  ]] ||  [[ "$VAR1" = "fedora"  ]] || [[ "$VAR1" = "redhat"  ]];
then 
	echo "Your OS is: " $VAR1
	echo "You have a Linxu Distro with YUM or DNDF"
elif [[ "$VAR1" = "ubuntu"  ]] ||  [[ "$VAR1" = "debian"  ]];
then
	echo "Your OS is:" $VAR1
	echo "You have a DEBIAN system... apt-get..."

else
	echo "Don't recognize this DISTRO" $VAR1
fi
