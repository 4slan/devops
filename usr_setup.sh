#!/bin/bash
# Lauch from root
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8 > /dev/null
echo "Auto-configuration of the Debian OS"
read -p "Please enter username that you want create: " username
echo -ne "Confirm that you want configurate OS for \033[31m$username\033[0m (y/n) "
read -n 1 confirm
echo
case $confirm in
	[yY])
		apt-get -qq update 
		apt-get -qqy upgrade | tail -1; echo
		apt-get -qqy install sudo pv > /dev/null
		adduser $username
		adduser $username sudo
esac
