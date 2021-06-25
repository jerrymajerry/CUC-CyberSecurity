#!bin/bash

#安装bind9

apt install -y bind9 || echo "install dns Failed"

#备份named.conf.options配置文件
if [[ ! -f /etc/bind/named.conf.options.bak ]]; then
	cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak
else
	echo "/etc/bind/named.conf.options.bak already Exists."
fi

cat>>/etc/bind/named.conf.options<<EOF
listen-on { 192.168.57.1; };
allow-transfer { none; };
forwarders {
    8.8.8.8;
    8.8.4.4;
};
EOF

#备份named.conf.local配置文件
if [[ ! -f /etc/bind/named.conf.local.bak ]]; then
	cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak
else
	echo "/etc/bind/named.conf.local.bak already Exists."
fi

cat>>/etc/bind/named.conf.local<<EOF
zone "cuc.edu.cn" {
    type master;
    file "/etc/bind/db.cuc.edu.cn";
};
EOF

#生成配置文件db.cuc.edu.cn
if [[ ! -f /etc/bind/db.cuc.edu.cn ]]; then
	cp /etc/bind/db.local /etc/bind/db.cuc.edu.cn
else
	echo "/etc/bind/db.cuc.edu.cn already Exists."
fi

cat /dev/null > /etc/bind/db.cuc.edu.cn
cat>>/etc/bind/db.cuc.edu.cn<<EOF
;
; BIND data file for local loopback interface
;
$TTL    604800
;@      IN      SOA     localhost. root.localhost.(

@       IN      SOA     cuc.edu.cn. admin.cuc.edu.cn. (
                            2         ; Serial
                        604800         ; Refresh
                        86400         ; Retry
                        2419200         ; Expire
                        604800 )       ; Negative Cache TTL
;
;@      IN      NS      localhost.
        IN      NS      ns.cuc.edu.cn.
ns      IN      A       192.168.57.1
wp.sec.cuc.edu.cn.      IN      A       192.168.57.1
dvwa.sec.cuc.edu.cn.    IN      CNAME   wp.sec.cuc.edu.cn.
@       IN      AAAA    ::1
EOF

# 重启bind9
service bind9.service restart

echo "finished"