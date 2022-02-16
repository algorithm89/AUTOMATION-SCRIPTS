#!/bin/bash 

sudo dnf update
sudo dnf install epel-release -y
sudo dnf install gcc make perl kernel-devel kernel-headers bzip2 dkms -y
sudo dnf update kernel-*

echo "Looking for VB0X Guest Additions"

read -p "What user is logged into this VM?:" USER1

echo $USER1

STR=$(ls -la /run/media/$USER1 | awk 'FNR == 4 {print $9}')
echo $STR

SUB="VBox"

 if [[ "$STR" == *"$SUB"* ]]; then
  echo "It's there."
  sudo cp -r /run/media/$USER1/VBox_GAs_6.1.32/VBoxLinuxAdditions.run /home/$USER1/Documents
  cd /home/$USER1/Documents && sudo ./VBoxLinuxAdditions.run
else
	echo "VBOX NOT MOUNTED"
fi


