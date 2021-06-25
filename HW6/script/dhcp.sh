#!bin/bash

echo "updating our package list"
apt update
if [[ $? -ne 0 ]]; then
	echo "update Failed"
	exit
fi

apt upgrade
if [[ $? -ne 0 ]]; then
	echo "upgrade Failed"
	exit
fi

#安装dhcp
echo "install dhcp"
command -v vsftpd > /dev/null
if [[ $? -ne 0 ]];then
		apt install isc-dhcp-server -y
		if [[ $? -ne 0 ]];then
				echo "install dhcp Failed"
				exit
		fi
else
		echo "dhcp is already installed"
fi

conf="/etc/dhcp/dhcpd.conf"

#备份配置文件
if [[ ! -f "${conf}.bak" ]];then
		cp "$conf" "$conf".bak
else
		echo "${conf}.bak already Exists"
fi

#向配置文件dhcpd.conf中添加
cat>>"$conf"<<EOF
# (add your comments here) 
default-lease-time 600;
max-lease-time 7200;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.1.255;
option routers 192.168.1.254;
option domain-name-servers 192.168.1.1, 192.168.1.2;
option domain-name "mydomain.example";

subnet 192.168.1.0 netmask 255.255.255.0 {
range 192.168.1.10 192.168.1.100;
range 192.168.1.150 192.168.1.200;
} 
EOF

#向配置文件01-netcfg.yaml中添加,变更machine-id
cat>>"/etc/netplan/01-netcfg.yaml"<<EOF
dhcp-identifier: mac
EOF


echo "finished"

#重启服务
service isc-dhcp-server restart