#!bin/bash

mv /var/lib/dpkg/info /var/lib/dpkg/info_old 
mkdir /var/lib/dpkg/info 
apt-get update
apt-get -f install 
mv /var/lib/dpkg/info/* /var/lib/dpkg/info_old 
rm -rf /var/lib/dpkg/info 
mv /var/lib/dpkg/info_old /var/lib/dpkg/info 

#安装resolvconf
apt install -y resolvconf || echo "install dns Failed"

#备份head配置文件
if [[ ! -f /etc/resolvconf/resolv.conf.d/head.bak ]]; then
	cp /etc/resolvconf/resolv.conf.d/head /etc/resolvconf/resolv.conf.d/head.bak
else
	echo "/etc/resolvconf/resolv.conf.d/head.bak already Exists."
fi

cat>>/etc/resolvconf/resolv.conf.d/head<<EOF
search cuc.edu.cn
nameserver 10.211.55.12
EOF