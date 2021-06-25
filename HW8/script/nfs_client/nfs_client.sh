#!bin/bash

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
mount -o nolock "$svr_ip":"$svr_export_r" "$client_export_r"
mount -o nolock "$svr_ip":"$svr_export_rw" "$client_export_rw"
mount -o nolock "$svr_ip":"$svr_export_rw_no_rs" "$client_export_rw_no_rs"
mount -o nolock "$svr_ip":"$svr_export_rw_rs" "$client_export_rw_rs"