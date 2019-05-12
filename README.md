# UniChat
IRC encrypted Chat in linux using netcat. 
This project is only working on locals ip

## Final goals : 
- Stable chat using a user password data base
- Messages are fully encrypted
- Server is dealing with multiple client and is able to remove clients 

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
You need to put the local IP of the server in the file [server_start.sh](https://github.com/Mathugo/UniChat/blob/master/server_start.sh)
```
#!/bin/bash
#IP="SERVER_IP" ## You need to put here the server IP
```
#### On Clients : 
You need to put the local IP of the client and the Server in the file [client.sh](https://github.com/Mathugo/UniChat/blob/master/client.sh)
```
#!/bin/bash
MY_IP="YOUR_IP"
IP="SERVER_IP"
```
## Authors
* **Nathan Haudot**
* **Alexandre Collard**
* **Hugo Math**

