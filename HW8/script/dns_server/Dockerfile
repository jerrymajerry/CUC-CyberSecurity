# Dockerfile for vsftpd 
FROM ubuntu

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN  apt-get clean

RUN apt-get update 

RUN mkdir script/

COPY dns_server.sh script/dns_server.sh

RUN bash script/dns_server.sh