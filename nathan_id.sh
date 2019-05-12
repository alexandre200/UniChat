#!/bin/bash


# Dépendances
OLDIFS="$IFS"
IFS=" "


#Variables globales
	#Menu1
let width=`tput cols`
let height=`tput lines`
let haut_height=height/2
let gauche_width=width/2
let gauche_width-=11
	#Menu2
let connected=0
let registered=0
let compteur=0
read_identifiant=""
read_motdepasse=""
pwd_db="pwd.db"

all_port="all_port.txt"
file_clport="cl_port.txt"
HOSTS="hosts.txt"
IP_temp="cl_ip.txt"
IP_allowed="ip_allowed.txt"
#FONCTIONS

function irc_motd()
{
	echo " _____ _____   _____    _____ _    _       _______  "
	echo "|_   _|  __ \ / ____|  / ____| |  | |   /\|__   __|"
	echo "  | | | |__) | |      | |    | |__| |  /  \  | |    "
	echo "  | | |  _  /| |      | |    |  __  | / /\ \ | |    "
	echo " _| |_| | \ \| |____  | |____| |  | |/ ____ \| |    "
	echo "|_____|_|  \_\\______|  \_____|_|  |_/_/    \_\_|    "
	echo "1.0 | @asterix4 @hu_math @qowax                      "
	echo "                                                     "
}

function encryption()
{
	# $1 = code à encrypter
	encryptee=$1

	# Retour de l'encryption
	retval=$encryptee
}

function entrerIdentifiants()
{
	clear
	irc_motd
	echo -n "Username : "
	read read_identifiant
	echo -n "Password : "
	while IFS= read -r -s -n1 pass
	do
		if [[ -z $pass ]]
		then
			echo
			break
		else
			echo -n '*'
			read_motdepasse+=$pass
		fi
	done
	clear
	let compteur+=1
}

function entrerIdentifiantsNouveauCompte()
{
	clear
	irc_motd
	echo "REGISTER"
	echo " "
	echo -n "Choose a username : "
	read read_identifiant
	echo -n "Choose a password : "

	while IFS= read -r -s -n1 pass
	do
		if [[ -z $pass ]]
		then
			echo
			break
		else
			echo -n '*'
			read_motdepasse+=$pass
		fi
	done
	clear
	let compteur+=1
}

function connexion()
{
	# $1 = identifiant
	# $2 = mot de passe

	irc_motd
	echo "ID: $1, trying to connect..."

	# Encryption des identifiants
	encryption $read_identifiant
	user_encrypte=$retval
	encryption $read_motdepasse
	pwd_encrypte=$retval

	# Recherche de correspondance dans la BDD
	let shunt=0
	while read id user pwd key
	do
		# Test de l'identifiant
		if [ "$user" = "$user_encrypte" ] && [ "$pwd" = "$pwd_encrypte" ] && [ $shunt -eq 0 ]
		then
			let shunt=1
		else
			echo -n " " # Ne rien faire
		fi
	done < $pwd_db

	# On récupère le résultat
	retval=$shunt
}

function enregistrer()
{
	
	#Compter lignes fichier des utilisateurs
	nb_lignes=`wc -l $pwd_db | cut -c1`
	
	let nb_lignes+=1
	
	#Générer clé serveur
	
	echo "$nb_lignes $read_identifiant $read_motdepasse key" >> $pwd_db
	
	let registered=1
	
}

##########################################################################################
##################################### PREMIER MENU #####################################
##########################################################################################

#Clear de l'écran
clear

#1er blanc de l'écran

for i in `seq 1 $haut_height`
do
	echo " "
done

#Espace entre les echo et le bord droit
for i in `seq 1 $gauche_width`
do
	echo -n " "
done
echo "1. Log in"
for i in `seq 1 $gauche_width`
do
	echo -n " "
done
echo "2. Register"
for i in `seq 1 $haut_height`
do
	echo " "
done

#Capture de la touche 1 ou 2
let choix=0
while [ $choix -eq 0 ]
do
	read touches
	#touches_appuyees=1
	#ancien_param_tty=$(stty -g)
	#stty -icanon -echo
	#touches=$(dd bs=1 count=$touches_appuyees 2> /dev/null)
	#stty "$ancien_param_tty"

	if [ $touches = "1" ]
	then
		let choix=1
	elif [ $touches = "2" ]
	then
		let choix=1
	fi
done

##########################################################################################
##################################### SECOND MENU ######################################
##########################################################################################

if [ $touches = "1" ]
then
#Connexion
	while [ $connected -eq 0 ] && [ $compteur -lt 1 ]
	do
		entrerIdentifiants
		connexion $read_identifiant $read_motdepasse

		# Test des identifiants
		echo " "
		if [ $retval -eq 1 ]
		then
			let connected=1
			echo "Connected!" ############### POint d'entré
			
			IP=`cat $IP_temp`
			#echo "IP : $IP"

			#local last_ip=`tail -n 1 $IP_allowed`
			#if [ "$IP" != "$last_ip" ];then # IF IT'S NOT THE SAME IP THEN ADD IT 
			#	echo "$IP" >> $IP_allowed
			#fi

			echo $IP >> $IP_allowed
			#echo "IP_allowed : `cat $IP_allowed`"	# ID OK 
			current_port=`cat $file_clport`
			echo $current_port >> $all_port
			echo "Port : $current_port"
			
			echo "$IP $read_identifiant $current_port" >> $HOSTS
			#echo "Hosts : `cat $HOSTS`"
			#echo "$current_port" >> $all_port

		else
			echo "Username or password incorrect."
			read_identifiant=""
			read_motdepasse=""
			sleep 1
		fi
	done
elif [ $touches = "2" ]
then
	#Enregistrement
	while [ $registered -eq 0 ]
		do
		entrerIdentifiantsNouveauCompte
	
		enregistrer
		
		echo "You are now registered!"
		sleep 1
		done
fi
