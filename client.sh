user="Hugo"

#IP="127.0.0.1"
IP="192.168.0.44"
let PORTID=1233
let PORT=1234
let PORT2=1235
let PORT_SEND=1236
let PORT_RECV=1237
let "id=0"

RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
NC='\033[0m' # No Color

msg_to_send=""
user=""
input=""
msg=""
filename="recv_client.txt"
recv_serv="recv_server.txt"
interface="wlp2s0"
#interface="eth0"
MY_IP=`ifconfig $interface | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

function clean()
{
	rm $recv_serv
	rm $filename
}
function print_status()
{
	echo -e "${YLW}[*] $msg_to_send${NC}"
}
function print_done()
{
	echo -e "${GRN}[*] $msg_to_send${NC}"
}
function print_error()
{
	echo -e "${RED}[X] $msg_to_send${NC}"
}
function print_warning()
{
	echo -e '${YLW}[!] $msg_to_send${NC}'
}

function ID()
{
	echo "|*] Sending IP"
	echo "$MY_IP" |netcat -q 1 $IP $PORT # q sert a envoyer sans attendre
	echo "[*] Done"
	sleep 0.5 # On attend le ncat du server
	netcat $IP $PORT # Le script ID est lancé
	sleep 0.5
	ncat --recv-only $IP $PORTID > $filename # ID marché ou pas ?
	msg=`cat $filename`
	#echo "msg : $msg"
	IFS=" " read -a array <<< "$msg"
	msg=${array[0]} # ON recupere le premier element 
	user=${array[1]} # ON recupere le deuxieme : user

	if [ "$msg" == "OK" ];then
		let "id=1"
	fi	
	sleep 3

}

function send_server()
{
	local send=""
	msg_to_send="You have now acces to the chat !\nYou can stop by pressing Ctrl-c or by taping exit"
	print_done
	while [ 1 -eq 1 ];do
		#echo -e ">> \c"
		sleep 0.1
		read input
		send=$user" "$input
		if [ "$input" = "exit" ];then
			echo "[!] Exiting .. "
			clean
			kill $pid1
			echo $send | ncat --send-only $IP $PORT_SEND 
			break
		fi	
		echo $send | ncat --send-only $IP $PORT_SEND 
	done
}

function compare()
{
	local user_c=$1
	
	if [ "$user_c" = "server" ];then
		echo -e "${GRN}[$user_c]${NC} $msg"
	elif [ "$user_c" != "$user" ];then	
		echo -e "${YLW}[$user_c]${NC} $msg"
	fi		
	#echo "[$user_c] $msg"
}
function recv_server()
{
	while [ "$input" != "exit" ];do
		ncat --recv-only $IP $PORT_RECV > $recv_serv 2>/dev/null
		msg=`cat $recv_serv`
		if [ "$msg" != "" ];then
			IFS=" " read -a msg_recv <<< "$msg"
			local user_recv=${msg_recv[0]}
			unset msg_recv[0]
			msg=""
			for str in "${!msg_recv[@]}";do
				msg=$msg${msg_recv[$str]}" "
			done
			compare	$user_recv
			#echo "[$user_recv] $msg"
		fi	
	done
}

function connection()
{
	echo "[!] Starting recv thread and send thread ...."
	recv_server &
	pid1=$!
	trap '{ ctrl_c; exit 1;}' INT
	echo "[*] Done"
	sleep 0.5
	send_server 

	wait $pid1 && echo "pid1 exited normally" || echo "pid1 exited abnormally with status $?"

}

function main()
{
	echo "[*] My IP : $MY_IP, interface: $interface"
	echo "[!] If the connection is not working, the server might be down"
	ID
	sleep 0.5
	if [ $id -eq 1 ];then
		echo "ID OK, now launching the chat ..."
		connection
	fi
}
function ctrl_c()
{
	echo "[!] Ctrl-c pressed, closing threads $pid1 and cleanning up .."
	kill $pid1
	clean
	echo "$user exit" |ncat --send-only $IP $PORT_SEND 
	echo "[*] Done"
}

main

#netcat $IP $PORT2 # Connection principale

#https://stackoverflow.com/questions/4739196/simple-socket-server-in-bash
# YOU CAN USE netcat -q 1 $IP $PORT to avoid waiting for more input.




#is_server_here
#recv_server 1 &
#pid1=$!
#send_server

#wait $pid1 && echo "pid1 exited normally" || echo "pid1 exited abnormally with status $?"


# Apres ID on utilise --allow pour les connecter


#mawk -W interactive '$0="Bob: "$0' | nc $IP $PORT
#https://askubuntu.com/questions/665492/how-to-build-a-simple-chat-using-netcat
# Il faut recuperer IP local, l'envoyer

