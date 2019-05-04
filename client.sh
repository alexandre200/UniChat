user="Hugo"

#IP="127.0.0.1"
IP="192.168.0.44"
let PORTID=1233
let PORT=1234
let PORT2=1235
let PORT_SEND=1236
let PORT_RECV=1237
let "id=0"

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
	echo "msg : $msg"
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
	while [ 1 -eq 1 ];do
		echo -e ">> \c"
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

function recv_server()
{
	while [ "$input" != "exit" ];do
		ncat --recv-only $IP $PORT_RECV > $recv_serv 2>/dev/null
		msg=`cat $recv_serv`
		if [ "$msg" != "" ];then
			echo "$msg"
		fi	
	done
}
function connection()
{
	echo "Starting recv thread and send thread ...."
	recv_server &
	pid1=$!
	trap '{ echo "[!] Ctrl-c pressed, closing threads $pid1 and cleanning up .."; kill $pid1;echo "[*] Done";clean; exit 1;}' INT
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

