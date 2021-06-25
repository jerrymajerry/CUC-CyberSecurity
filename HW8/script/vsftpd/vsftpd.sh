#!/bin/bash
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
#创建匿名用户测试用的文件目录
if [[ ! -d "${anonymous_path}" ]];then 
	mkdir -p "$anonymous_path"
	echo "anonymous file is created"
fi
#设置其所有权
chown nobody:nogroup "$anonymous_path"
#添加一个在测试时使用的文件test_a.txt
echo "vsftpd test file for anonymous user" | tee "${anonymous_path}/test_a.txt"

#修改配置文件vsftpd.conf
config=/etc/vsftpd.conf
if [[ ! -f "${config}.bak" ]];then
	cp "$config" "$config".bak
fi
#允许匿名用户访问
sed -i -e '/anonymous_enable=/s/NO/YES/g;/anonymous_enable=/s/#//g' "$config" 
sed -i -e '/local_enable=/s/NO/YES/g;/local_enable=/s/#//g' "$config"
sed -i -e '/write_enable=/s/NO/YES/g;/write_enable=/s/#//g' "$config"
#不允许匿名用户创建新目录
sed -i -e '/anon_mkdir_write_enable=/s/YES/NO/g' "$config"
#不允许匿名用户上传文件
sed -i -e '/anon_upload_enable=/s/YES/NO/g;/anon_upload_enable=/s/#//g' "$config"
#防止用户访问目录树之外的任何文件或命令
sed -i -e '/chroot_local_user=/s/NO/YES/g;/chroot_local_user=/s/#//g' "$config"

#设置用户名和密码方式访问的账号
user="sammy"
#添加测试用户sammy
if [[ $(grep -c "^$user:" /etc/passwd) -eq 0 ]];then
	useradd $user
	echo "created a new user:$user"
else
	echo "user ${user} already exists "
fi

#创建用户目录
user_path="/home/${user}/ftp"
if [[ ! -d "$user_path" ]];then 
	mkdir -p "$user_path"
	echo "user file is created"
fi

#设置其所有权
chown nobody:nogroup "$user_path"
user_write_path="${user_path}/files"

#创建用户的上传目录
if [[ ! -d "$user_write_path" ]];then 
	mkdir "$user_write_path"
	echo "user test file is created"
fi
#将所有权分配给用户
chown "$user":"$user" "$user_write_path"
ls -la "$user_write_path"
echo "vsftpd test file for the login user" | tee "${user_write_path}/test_b.txt"
# 将用户添加到userlist文件(白名单)
grep -q "$user" /etc/vsftpd.userlist ||  echo "$user" | tee -a /etc/vsftpd.userlist
grep -q "anonymous" /etc/vsftpd.userlist || echo "anonymous" | tee -a /etc/vsftpd.userlist

if [[ -z $(cat "$config" | grep "userlist_file=/etc/vsftpd.userlist") ]];then
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
grep -q "vsftpd:ALL" /etc/hosts.deny || echo "vsftpd:ALL" >> /etc/hosts.deny
grep -q "vsftpd:10.211.55.6" /etc/hosts.allow || echo "vsftpd:10.211.55.6" >> /etc/hosts.allow

#重新启动服务器以使更改生效
service vsftpd restart

echo "finished"
