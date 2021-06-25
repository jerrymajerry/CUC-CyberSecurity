# Dockerfile for vsftpd 
FROM ubuntu

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN  apt-get clean

RUN apt-get update 

RUN mkdir script/

COPY vsftpd.sh script/vsftpd.sh

RUN bash script/vsftpd.sh