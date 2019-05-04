#!/bin/bash

#IP="172.30.68.204"
IP="192.168.0.44"
let PORT=1234
IP_temp="cl_ip.txt"
IP_allowed="ip_allowed.txt"
user=""
passwd=""
trusted_host=""
HOSTS="hosts.txt"


function ID()
{
	echo "Welcome to the IRC Chat : UniCHAT"
	echo "Please enter your ID'S, "
	echo -e "user: \c"
	read user
	echo -e "password : \c"
	read passwd
	echo "Welcome $user ! "
	echo "You have now acces to the chat, if you want to exit just enter exit"
	#
	#	Check les ID par nathan
	#	Si --> on accepte cet IP
	#
	IP=`cat $IP_temp`
	local last_ip=`tail -n 1 $IP_allowed`
	if [ "$IP" != "$last_ip" ];then # IF IT'S NOT THE SAME IP THEN ADD IT 
		echo "$IP" >> $IP_allowed
	fi		

	echo "IP_allowed : `cat $IP_allowed`"	# ID OK 
	echo "$IP $user $passwd" >> $HOSTS
}

ID
#recv
#chat
