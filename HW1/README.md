# 实验报告

## 无人值守安装iso

### 软件环境

Mac os Catalina
Parallels Desktop for Mac
Ubuntu-18.04.4-server-amd64

设置该虚拟机的两块网络网卡：host-only和NAT
启动虚拟机
创建一个用于挂载iso镜像文件的目录
*mkdir loopdir*
挂载iso镜像文件到该目录
*mount -o loop ubuntu-16.04.1-server-amd64.iso loopdir*

#### error1

![1](/image/error1-需修改root权限.png)

#### 解决：修改root权限

![1](/image/error1-解决.png)

#### error2

![1](/image/error2-镜像挂载失败.png)

#### 解决：

在loopdir目录下找不到该iso文件，选择使用Mac自带SSH进行远程传输文件到虚拟机上。
![1](/image/查询ip.png)
连接
![1](/image/连接.png)

#### error3

在Mac上尝试连接成功，但仍然无法传输文件
![1](/image/error3-传输失败.png)

#### 解决

直到看到了这篇文
![1](/image/csdn.png)
原来要退出连接再传文件！

#### error4

传输失败
![1](/image/error4-传输失败.png)

#### 请教老师后解决

:/loopdir应该是:~/loopdir
![1](/image/远程传输镜像至虚拟机成功.png)

确认镜像导入成功
![1](/image/确认镜像导入成功.png)
![1](/image/确认挂载.png)

创建一个工作目录用于克隆光盘内容
*mkdir cd*
同步光盘内容到目标工作目录
*rsync -av loopdir/ cd*
卸载iso镜像
*umount loopdir*
![1](/image/同步光盘内容到目标工作目录.png)
![1](/image/卸载iso镜像.png)

下载vim,编辑Ubuntu安装引导界面增加一个新菜单项入口
*vim isolinux/txt.cfg*

添加以下内容到该文件后强制保存退出

*label autoinstall
  menu label ^Auto Install Ubuntu Server
  kernel /install/vmlinuz
  append  file=/cdrom/preseed/ubuntu-server-autoinstall.seed debian-installer/locale=en_US console-setup/layoutcode=us keyboard-configuration/layoutcode=us console-setup/ask_detect=false localechooser/translation/warn-light=true localechooser/translation/warn-severe=true initrd=/install/initrd.gz root=/dev/ram rw quiet*

#### error5

传输文件再次失败
![1](/image/传输文件再次失败.png)

#### 解决

当发现只能传输到loopdir时怀疑是权限问题，于是百度方法打算在Ubuntu中将文件move到preseed下，但由于执行语句错误没有成功，后在老师指导下成功解决。
![1](/image/解决error5.png)

#### error6

无法修改文件
![1](/image/error6.png)

#### 解决

![1](/image/error6解决.png)

#### error7

![1](/image/error7.png)

无法解决不能复制粘贴的问题，初步怀疑是某个地方打错了。

#### 解决

通过Mac SSH远程连接虚拟机，在Mac终端操作
![1](image/error7解决.png)
