#!/bin/bash

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


# 目标主机安装vsftpd
echo "install vsftpd"
command -v vsftpd > /dev/null
if [[ $? -ne 0 ]];then
		apt install vsftpd -y
		if [[ $? -ne 0 ]];then
				echo "install vsftpd Failed"
				exit
		fi
else
		echo "vsftpd is already installed"
fi

#备份vsftpd配置文件
if [[ ! -f /etc/vsftpd.conf.bak ]]; then
	cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
else
	echo "/etc/vsftpd.conf.bak already Exists."
fi

#配置匿名访问的FTP服务器
#创建匿名用户可访问的文件夹
anonymous_path="/var/ftp/anonymous"
if [[ ! -d "$anonymous_path" ]];
then
	mkdir -p "$anonymous_path"
else
		echo "${anonymous_path} is already Exists"
fi
#设置其所有权
chown nobody:nogroup "$anonymous_path"
#添加一个在测试时使用的文件test.txt
echo "vsftpd test file" | tee "${anonymous_path}/test.txt"

#修改配置文件vsftpd.conf
#允许匿名用户访问
sed -i -e "/anonymous_enable=/s/NO/YES/g;/anonymous_enable=/s/#//g" /etc/vsftpd.conf
#不允许匿名用户上传文件
sed -i -e "/anon_upload_enable=/s/YES/NO/g;/anon_upload_enable=/s/#//g" /etc/vsftpd.conf
#不允许匿名用户创建新目录
sed -i -e "/anon_mkdir_write_enable=/s/YES/NO/g" /etc/vsftpd.conf
#防止用户访问目录树之外的任何文件或命令
sed -i -e "/chroot_local_user=/s/NO/YES/g;/chroot_local_user=/s/#//g" /etc/vsftpd.conf

#设置用户名和密码方式访问的账号
user="sammy"
#添加测试用户sammy
if [[ $(grep -c "^$user:" /etc/passwd) -eq 0 ]];then
		useradd $user
		passwd $user
else
		echo "User ${user} is already Exists"
fi
#创建用户目录
user_path="/home/${user}/ftp"
if [[ ! -d "$user_path" ]];
then
		mkdir -p "$user_path"
else
		echo "${user_path} is already Exists"
fi
#设置其所有权
chown nobody:nogroup "$user_path"
#对该目录的只读权限（删除写）
chmod a-w "$user_path"
#创建用户的上传目录
another_user_path="${user_path}/files"
if [[ ! -d "$another_user_path" ]];
then
		mkdir -p "$another_user_path"
else
		echo "${another_user_path} is already Exists"
fi
#将所有权分配给用户
chown "$user":"$user" "$another_user_path"
#添加一个在测试时使用的文件test.txt
echo "vsftpd test file" | tee "${another_user_path}/test.txt"
#修改配置文件vsftpd.conf
#允许本地登录
sed -i -e "/local_enable=/s/NO/YES/g;/local_enable=/s/#//g" /etc/vsftpd.conf
#允许写文件
sed -i -e "/write_enable=/s/NO/YES/g;/write_enable=/s/#//g" /etc/vsftpd.conf
#防止用户访问目录树之外的任何文件或命令(已改)


# 将用户添加到userlist文件(白名单)
grep -q "$user" /etc/vsftpd.userlist ||  echo "$user" | tee -a /etc/vsftpd.userlist
grep -q "anonymous" /etc/vsftpd.userlist || echo "anonymous" | tee -a /etc/vsftpd.userlist
#向配置文件vsftpd.conf添加
if [[ -z $(cat /etc/vsftpd.conf | grep "userlist_file=/etc/vsftpd.userlist") ]]; then
	cat>>/etc/vsftpd.conf<<EOF
#限制可用于被动FTP的端口范围，以确保有足够的可用连接
pasv_min_port=40000
pasv_max_port=50000
#只允许白名单用户访问ftp
userlist_file=/etc/vsftpd.userlist
userlist_enable=YES
userlist_deny=NO

tcp_wrappers=YES
anon_root=/var/ftp/
no_anon_password=YES
hide_ids=YES
EOF
fi

#只允许白名单用户访问ftp
grep -q "vsftpd: ALL"  /etc/hosts.deny || echo "vsftpd: ALL" >> /etc/hosts.deny
grep -q "vsftpd:10.211.55.6"  /etc/hosts.deny || echo "vsftpd:10.211.55.6" >> /etc/hosts.allow

echo "finished"

#重新启动服务器以使更改生效
systemctl restart vsftpd