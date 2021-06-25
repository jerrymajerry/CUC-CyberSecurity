#!bin/bash

#主机
echo "install nfs"
apt install -y nfs-kernel-server || echo "install nfs Failed"


svr_export_r="/var/nfs/general_r"
svr_export_rw="/var/nfs/general_rw"

svr_no_rs="/home/no_rs"
svr_rs="/home/rs"
client_ip="10.211.55.6"
client_export_rw_op="rw,sync,no_subtree_check"
client_export_r_op="ro,sync,no_subtree_check"
client_export_rw_no_rs="rw,sync,no_root_squash,no_subtree_check"
client_export_rw_rs="rw,sync,no_subtree_check"
conf="/etc/exports"

#创建一个共享目录(只读访问)
mkdir -p "$svr_export_r"
chown nobody:nogroup "$svr_export_r"
#创建一个共享目录(读写访问)
mkdir -p "$svr_export_rw"
chown nobody:nogroup "$svr_export_rw"

mkdir -p "$svr_no_rs"
mkdir -p "$svr_rs"


grep -q "$svr_export_r" "$conf" && sed -i -e "#${svr_export_r}#s#^[#]##g;#${svr_export_r}#s#\ .*#${client_ip}($client_export_r_op)" "$conf" || echo "${svr_export_r} ${client_ip}($client_export_r_op)" >> "$conf"

grep -q "$svr_export_rw" "$conf" && sed -i -e "#${svr_export_rw}#s#^[#]##g;#${svr_export_rw}#s#\ .*#${client_ip}($client_export_rw_op)" "$conf" || echo "${svr_export_rw} ${client_ip}($client_export_rw_op)" >> "$conf"

grep -q "$svr_no_rs" "$conf" && sed -i -e "#${svr_no_rs}#s#^[#]##g;#${svr_no_rs}#s#\ .*#${client_ip}  ($client_export_rw_no_rs)" "$conf" || echo "${svr_no_rs} ${client_ip}($client_export_rw_no_rs)" >> "$conf"

grep -q "$svr_rs" "$conf" && sed -i -e "#${svr_rs}#s#^[#]##g;#${svr_rs}#s#\ .*#${client_ip}  ($client_export_rw_rs)" "$conf" || echo "${svr_rs} ${client_ip}($client_export_rw_rs)" >> "$conf"


#重新启动NFS服务器
service nfs-kernel-server restart

echo "finished"