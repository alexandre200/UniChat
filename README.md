# UniChat
IRC encrypted Chat in linux using netcat. 
This project is only working on locals ip

## Final goals : 
- Stable chat using a user password data base
- Messages are fully encrypted
- Server is dealing with multiple client and is able to remove clients 

## How it works
### Server :
1 thread which allow to launch the identification in the back and an loop to receive messages from all clients and to send it
Clients are stored in hosts.txt with : $IP $user $port $clientpubkey
1 port is used per client because netcat cannot send a message to a specific client using the same port as the others.
So, the client connects to the IP server and then the [nathan_id.sh](https://github.com/Mathugo/UniChat/blob/master/Server/nathan_id.sh) script is launched using the data base [pwd.db](ttps://github.com/Mathugo/UniChat/blob/master/Server/pwd.db) structured like : $key $user $mdp $clientpubkey. If it's successful the client can access to the chat, otherwise it exits. 

### Client : 
1 thread which recv message from the server at a specific port proper to the client and a loop to send message to the server.
The client sends his IP and try to log in, if it's successful then he access to the chat.

### Encryption :
First of all, the messages are fully encrypted using RSA. The server send his publicKey to a client who is trying to connect and then the client encrypts his publickey using the serverpublickey and send it to the server which decrypt it and add it to the hosts.txt. After that, when a client is trying to send a message to the server, it's encrypted using his publickey. The server receives the encrypted message and decrypt it, then for all clients the server encrypt the message using special publickey (one per client) and send it to the clients. 

## Getting started
These instructions will get you a copy of the project up and running on your local machine.

### Prerequisites
You need to install the netcat package.
Exemple in ubuntu deb : 
```
  sudo apt-get update
  sudo apt-get install build-essential netcat nc
```
### Setting up the project
You can get your local ip adress by taping : 
```
ifconfig
```
And then choose the right one with the right interface (wlan0,eth0 ...)
#### On Server : 
You need to put the local IP of the server in the file [server_start.sh](https://github.com/Mathugo/UniChat/blob/master/Server/server_start.sh)
```
#!/bin/bash
#IP="SERVER_IP" ## You need to put here the server IP
.
.
.
```
#### On Clients : 
You need to put the local IP of the client and the Server in the file [client.sh](https://github.com/Mathugo/UniChat/blob/master/Client/client.sh)
```
#!/bin/bash
MY_IP="YOUR_IP"
IP="SERVER_IP"
.
.
.
```
## Authors
* **Nathan Haudot**
* **Alexandre Collard**
* **Hugo Math**

