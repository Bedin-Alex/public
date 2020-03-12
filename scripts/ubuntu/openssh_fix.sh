#!/bin/bash
Cyan='\033[0;36m'
NC='\033[0m'

apt install -y build-essential libssl-dev zlib1g-dev

current_version_ssl=`openssl version | awk '{print $2}'`
current_version_ssh=`echo ~ | nc localhost 22 | awk 'NR==1{print $1}' | cut -f 2 -d "_" | cut -c 1-3`

if [[ `echo $current_version_ssl | cut -c1` -le 1 ]] && [[ `echo $current_version_ssl | cut -c3` -lt 1 ]];then
	echo -e "Installing ${Cyan}OpenSSL v1.1.1${NC}"
	wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz
	tar -zxvf openssl-1.1.1d.tar.gz
	cd openssl-1.1.1d
	./config
	make
	make test
	make install
fi

if [[ `echo $current_version_ssh | cut -c1` -le 7 ]] && [[ `echo $current_version_ssh | cut -c3` -lt 7 ]];then
	echo -e "Updating ${Cyan}OpenSSH${NC}"
	wget http://mirrors.edge.kernel.org/ubuntu/pool/main/o/openssh/openssh_7.9p1.orig.tar.gz
	tar xfz openssh_7.9p1.orig.tar.gz
	cd openssh-7.9p1/
	./configure
	make
	iptables -L
	make install
fi

echo -e "You should reconnect to the server via SSH and try get command ${Cyan}ssh -V${NC}"
