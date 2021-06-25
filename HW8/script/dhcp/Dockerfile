# Dockerfile for vsftpd 
FROM ubuntu

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN  apt-get clean

RUN apt-get update 

RUN apt-get upgrade

RUN mkdir script/

COPY dhcp.sh script/dhcp.sh

RUN bash script/dhcp.sh