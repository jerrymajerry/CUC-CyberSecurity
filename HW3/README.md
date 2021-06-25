# SYSTEMD 入门教程学习

## 视频清单

### 入门篇3.1-4.4

<a href="https://asciinema.org/a/xlc0lwByd9Q0bik8E6nFTrxoj" target="_blank"><img src="https://asciinema.org/a/xlc0lwByd9Q0bik8E6nFTrxoj.svg" /></a>

### 入门篇4.5-7

[![asciicast](https://asciinema.org/a/RusNN2DEAwzowWIF8ywR80ZH3.svg)](https://asciinema.org/a/RusNN2DEAwzowWIF8ywR80ZH3)

### 实战篇

[![asciicast](https://asciinema.org/a/2E7uRA6YmsGdwacyTlBpmVYdr.svg)](https://asciinema.org/a/2E7uRA6YmsGdwacyTlBpmVYdr)

### 自查清单

如何添加一个用户并使其具备sudo执行程序的权限？

    添加用户 
    useradd xxx

    分配用户权限
    sudo chmod +w /etc/sudoers
    sudo vim /etc/sudoers

    添加需要sudo权限的用户名
    root　ALL=(ALL:ALL) ALL
    xxx ALL=(ALL:ALL) ALL

    将sudoers文件的操作权限改为只读模式
    sudo chmod -w /etc/sudoers

如何将一个用户添加到一个用户组？

    usermod -a -G xxx(group) xxx(user)

如何查看当前系统的分区表和文件系统详细信息？
    sudo fdisk -l

基于LVM（逻辑分卷管理）的分区如何实现动态扩容和缩减容量？

    参考https://blog.51cto.com/13691477/2299707

如何通过systemd设置实现在网络连通时运行一个指定脚本，在网络断开时运行另一个脚本？

    修改networking.service
    ExecStartPost=脚本1位置
    ExecStopPost=脚本2位置

如何通过systemd设置实现一个脚本在任何情况下被杀死之后会立即重新启动？实现杀不死？

    修改该脚本service的Unit中Restart=always
