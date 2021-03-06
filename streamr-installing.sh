#!/bin/bash
mkdir $HOME/.streamrDocker
sudo apt update
sudo apt-get install docker.io -y
sudo apt-get install expect -y
expect <<END
	set timeout 300
	spawn docker run -it -v $(cd ~/.streamrDocker; pwd):/root/.streamr streamr/broker-node:testnet bin/config-wizard
	expect "Do you want to generate"
	send -- "\n"
	expect "We strongly recommend backing up your private key."
	send -- "\n"
	expect "Select the plugins to enable"
	send -- "a\n"
	expect "Provide a port for the websocket Plugin"
	send -- "\n"
	expect "Provide a port for the mqtt Plugin"
	send -- "\n"
	expect "Provide a port for the publishHttp Plugin"
	send -- "\n"
	expect "Select a path to store the generated config"
	send -- "\n"
	expect eof
END
docker pull streamr/broker-node:testnet
docker run -it --restart=always --name=streamr_node -d -p 7170:7170 -p 7171:7171 -p 1883:1883 -v $(cd ~/.streamrDocker; pwd):/root/.streamr streamr/broker-node:testnet
