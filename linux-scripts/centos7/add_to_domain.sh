#!/bin/bash
Cyan='\033[0;36m'
NC='\033[0m'
domain='norbit.ru'
echo -e "${Cyan}Step 0.${NC} Installing packages."
yum install realmd sssd adcli krb5-workstation oddjob oddjob-mkhomedir samba-common-tools -y > /dev/null >&1
echo -e "${Cyan}Step 1.${NC} Discovering domain."
realm discover $domain –verbose
echo -e "${Cyan}Step 2.${NC} Enter login ${Cyan}(NOT an e-mail)${NC} of ${Cyan}ADMIN AD${NC}:"
read login
full_login=$login"@$domain"
realm join $domain -U $full_login
echo -e "Do you want to create a white list ${Cyan}(give a permissions)${NC} of users, who should get a remote control via ssh? ${Cyan}[y/n]${NC}"
read prompt
if [ $prompt == "y" ];then
        echo -e "${Cyan}Step 4.${NC} Enter an ${Cyan}e-mail${NC} addresses of users, who should to login on this server? Separates [,]:"
        read users
        list=`echo "$users" | sed 's/,/ /g'`
        realm permit $list
fi
