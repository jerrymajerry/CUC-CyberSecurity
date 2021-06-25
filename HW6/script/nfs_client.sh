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

#客户端
apt install -y nfs-common || echo "install nfs Failed"


svr_ip="10.211.55.12"
svr_export_r="/var/nfs/general_r"
svr_export_rw="/var/nfs/general_rw"
svr_export_rw_no_rs="/home/no_rs"
svr_export_rw_rs="/home/rs"
client_export_r="/nfs/general_r"
client_export_rw="/nfs/general_rw"
client_export_rw_no_rs="/nfs/no_rs"
client_export_rw_rs="/nfs/rs"

#创建挂载点和挂载目录
mkdir -p "$client_export_r"
mkdir -p "$client_export_rw"
mkdir -p "$client_export_rw_no_rs"
mkdir -p "$client_export_rw_rs"
mount "$svr_ip":"$svr_export_r" "$client_export_r"
mount "$svr_ip":"$svr_export_rw" "$client_export_rw"
mount "$svr_ip":"$svr_export_rw_no_rs" "$client_export_rw_no_rs"
mount "$svr_ip":"$svr_export_rw_rs" "$client_export_rw_rs"