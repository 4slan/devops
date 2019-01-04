#!/bin/bash
# Configuration of server from non root user
PLAY_GAME="Please launch me again and play the game"
clear
printf "+-----------------------------------------------------------------------+\n| "
echo -n "Hello!" | pv -qL 15
printf "                                                                |\n| "
echo -n "I am Jessy and I'll configurate your server in 30 seconds. I am" | pv -qL 15
printf "       |\n| "
echo -ne "not totally automated \033[3m(at least at the moment if my creator will not\033[0m" | pv -qL 15
printf "  |\n| "
echo -ne "\033[3mforget to make me more intelligent)\033[0m. So, I'll need your help." | pv -qL 15
printf "         |\n| "
echo -n "By the way, forgive my English, as my creator is not very good in" | pv -qL 15
printf "     |\n| "
echo -n "English, I have inherited it from him." | pv -qL 15
printf "                                |\n| "
printf "                                                           "
echo -ne "\033[1mLGRTR!\033[0m" | pv -qL 5
printf "     |\n+-----------------------------------------------------------------------+\n"
echo "Please wait... I'm doing something"
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8 > /dev/null
sudo apt-get -yqq install git iptables-persistent fail2ban psad
clear
sudo git clone https://github.com/4slan/devops.git devops &> /dev/null
read -p "Could you please configurate your interface as static (y/n) " -n 1
case $REPLY in
	[yY])
		sudo vi /etc/network/interfaces
		;;
	*)
		printf "\n$PLAY_GAME"
		echo
		exit 1
		;;
esac
echo
while read -p "Chose SSH port between 1000 and 65535 : " PORT;
do
	if ! [[ ( "$PORT" =~ ^[0-9]+$ ) ]]
	then
		echo "Sorry the port need to be and integer" | pv -qL 15
	else
		break
	fi
done
sudo sed -i "s/.*Port .*/Port ${PORT}/g" /etc/ssh/sshd_config
sudo sed -i "s/.*PermitRootLogin .*/PermitRootLogin no/g" /etc/ssh/sshd_config
sudo service sshd restart
echo "You need to generate an key on your Host machine as follow" | pv -qL 15
echo -e "\t\033[1mssh-keygen\033[0m"
echo -e "\t\033[1mssh-copy-id $USER@$(hostname -I)-p $PORT\033[0m"
echo -e "\033[5m\033[7mDo you confirm that you have copied your public key (y/n) \033[0m"
read -n 1
case $REPLY in
	[yY])
		sudo sed -i "s/.*PubkeyAuthentication .*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
		sudo sed -i "s/.*PasswordAuthentication .*/PasswordAuthentication no/g" /etc/ssh/sshd_config
		;;
	*)
		printf "\n$PLAY_GAME\n"
		exit
		;;
esac
echo
echo "Now you are able to work through SSH from your machine which is great" | pv -qL 15
sudo cp ~/devops/addition/firewall /etc/init.d/
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo sed -i "s/action \= \%\(action\_\)s/action \= \%\(action_mwl\)s/g" /etc/fail2ban/jail.local
read -p "Please put enables = true, maxretry = 3, port = 2222 and logpath =/var/log/auth.log"
sudo vi /etc/fail2ban/jail.local
echo "Copy the following line in file that open when you press [enter]" | pv -qL 15
echo -e "\t\033[1mkern.info\t|/var/lib/psad/psadfifo\033[0m"
read
sudo vi /etc/syslog.conf
sudo service syslog restart
sudo sed -i "s/EMAIL_ADDRESSES .*/EMAIL_ADDRESSES\t\troot\@localhost\,amalsago\@student\.42\.fr;/g" /etc/psad/psad.conf
sudo sed -i "s/HOSTNAME .*/HOSTNAME\t\t$(hostname)/g" /etc/psad/psad.conf
sudo sed -i "s/ENABLE_SYSLOG_FILE .*/ENABLE_SYSLOG_FILE Y;/g" /etc/psad/psad.conf
sudo sed -i "s/IPT_WRITE_FWDATA .*/IPT_WRITE_FWDATA\tY;/g" /etc/psad/psad.conf
sudo sed -i "s/ENABLE_AUTO_IDS .*/ENABLE_AUTO_IDS\t\tY;/g" /etc/psad/psad.conf
sudo sed -i "s/AUTO_IDS_DANGER_LEVEL .*/AUTO_IDS_DANGER_LEVEL\t1;/g" /etc/psad/psad.conf
sudo psad --sig-update
sudo psad -R
sudo cp ~/devops/addition/update_packages /etc/cron.d/
sudo chmod +x /etc/cron.d/update_packages
sudo cp ~/devops/addition/cron_integrity /etc/cron.d/cron_integrity
sudo chmod +x /etc/cron.d/cron_integrity
echo "Write following line in crontab" | pv -qL 15
echo -e "\t\033[1m0 4 * * 2       /etc/cron.d/update_packages\033[0m"
echo -e "\t\033[1m@reboot         /etc/cron.d/update_packages\033[0m"
echo -e "\t\033[1m0 0 * * *       /etc/cron.d/cron_integrity\t\033[0m"
read
sudo crontab -e
sudo rm -rf ~/devops
echo -e "\033[1mI'll now disconnect you and you then you need to relog to your session with a chossen port\033[0m"
sudo sh /etc/init.d/firewall
sudo netfilter-persistent save
sudo pkill -u $LOGNAME
