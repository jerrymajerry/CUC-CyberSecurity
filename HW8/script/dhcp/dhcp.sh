#!bin/bash

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

dhcp_conf1="/etc/dhcp/dhcpd.conf"
dhcp_conf2="/etc/default/isc-dhcp-server"
dhcp_conf3="/etc/netplan/01-netcfg.yaml"

#备份配置文件
if [[ ! -f "${dhcp_conf1}.bak" ]];then
	cp "$dhcp_conf1" "$dhcp_conf1".bak
fi

if [[ ! -f "${dhcp_conf2}.bak" ]];then
	cp "$dhcp_conf2" "$dhcp_conf2".bak
fi

if [[ ! -f "${dhcp_conf3}.bak" ]];then
	cp "$dhcp_conf3" "$dhcp_conf3".bak
fi

#向配置文件dhcpd.conf中添加
cat>>"$dhcp_conf1"<<EOF
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

cat<<EOT >> "$dhcp_con3"
    enp0s9:
      dhcp4: no
      addresses: [10.211.55.1/24]
EOT


#修改配置文件中内容
sed -i -e "/INTERFACESv4=/s/^[#]//g;/INTERFACESv4=/s/\=.*/=\"enp0s9\"/g" "$dhcp_con2"
sed -i -e "/INTERFACESv6=/s/^[#]//g;/INTERFACESv4=/s/\=.*/=\"enp0s9\"/g" "$dhcp_con2"

#重启服务
service isc-dhcp-server restart

echo "finished"
