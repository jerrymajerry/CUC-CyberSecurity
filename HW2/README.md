**安装**

`sudo apt_get install asciinema`

**关联账户**

`asciinema auth`

**lesson1 视频**
[![asciicast](https://asciinema.org/a/dnUq6MyPRbtFrn4MunCGYYoba.svg)](https://asciinema.org/a/dnUq6MyPRbtFrn4MunCGYYoba)

**lesson2 视频**
[![asciicast](https://asciinema.org/a/zbNADRKXCAZ9gmVEdDfxjenyW.svg)](https://asciinema.org/a/zbNADRKXCAZ9gmVEdDfxjenyW)

**lesson3 视频**
[![asciicast](https://asciinema.org/a/YRfn4gtNW42wRVm00x5kqLdKs.svg)](https://asciinema.org/a/YRfn4gtNW42wRVm00x5kqLdKs)

**lesson4 视频**
[![asciicast](https://asciinema.org/a/z5U0BJRg7HxzsBQwovFcLjAAe.svg)](https://asciinema.org/a/z5U0BJRg7HxzsBQwovFcLjAAe)

**lesson5 视频**
[![asciicast](https://asciinema.org/a/20mmcDFQmvEHI0gV8PwVof2Y5.svg)](https://asciinema.org/a/20mmcDFQmvEHI0gV8PwVof2Y5)

**lesson 6 视频**
[![asciicast](https://asciinema.org/a/OH4edd1BwFGzgMFC4NWXYAq4X.svg)](https://asciinema.org/a/OH4edd1BwFGzgMFC4NWXYAq4X)

**lesson7 视频**
[![asciicast](https://asciinema.org/a/2wXxR4VNxQPwMolAdbTY9gOJi.svg)](https://asciinema.org/a/2wXxR4VNxQPwMolAdbTY9gOJi)

**你了解vim有哪几种工作模式？**

常规模式(normal)、命令模式（command）、插入模式(insert)、视图模式(visual）、替换模式（replace）

**Normal模式下，从当前行开始，一次向下移动光标10行的操作方法？如何快速移动到文件开始行和结束行？如何快速跳转到文件中的第N行？**

一次向下移动10行：`10j`

移动到开始行：`gg`

移动到结束行：`G`

跳转到第N行：`NG`

**Normal模式下，如何删除单个字符、单个单词、从当前光标位置一直删除到行尾、单行、当前行开始向下数N行？**

删除单个字符：`x` （删除光标所在位置字符）

删除单个单词：`dw` （光标移动到下一个词的首字母位置）

当前位置一直删除到行尾：`d$`

删除单行：`dd`

删除当前行开始向下数N行：`Ndd`

**如何在vim中快速插入N个空行？如何在vim中快速输入80个-？**

快速插入N个空行：`No`（向下插入） `NO`（向上插入）

快速输入80个_：`80i_`（行首插入） `80A_`（行尾插入） `80a_`（下一个字符插入）

**如何撤销最近一次编辑操作？如何重做最近一次被撤销的操作？**

撤销最近一次编辑：`u`

重做最近一次编辑：`CTRL+R`

**vim中如何实现剪切粘贴单个字符？单个单词？单行？如何实现相似的复制粘贴操作呢？**

单个字符：`x+p`

单个单词：`dw+p`

单行：`dd+p`

复制粘贴：`CTRL-V`进入Visual mode，移动光标将从光标起始位置选中文本,`y`,esc后`p`

**为了编辑一段文本你能想到哪几种操作方式（按键序列）？**

光标移动：`h` 左 `j` 下 `k` 上 `l` 右 `G` 移动至文件尾 `gg` 移动至文件顶部

退出：`:q!` 撤销改动 `:wq` 保存改动

删除：`x` 字符 `dw` 一个单词 `d$` 至行尾 `dd` 整行

插入内容：`i` 光标前插入 `a` 光标后插入 `A` 行尾 `o` 光标下插入一行 `O`光标上插入一行

撤销：`u` 前一个操作 `U` 当前行的所有操作 `CTRL-R` 重做

替换：`rx` `:s/old/new:` 把光标之后第一个old替换成new

复制：`y` 粘贴：`p`

**查看当前正在编辑的文件名的方法？查看当前光标所在行的行号的方法？**

`CTRL+G`

**在文件中进行关键词搜索你会哪些方法？如何设置忽略大小写的情况下进行匹配搜索？如何将匹配的搜索结果进行高亮显示？如何对匹配到的关键词进行批量替换？**

关键词搜索：`/关键词`（向下查找） `?关键词`（向上查找）

忽略大小写：`:set ic`（ignorecase)

高亮显示：`set hls is`

批量替换：`N:s/old/new/g` N为替换的行的范围

**在文件中最近编辑过的位置来回快速跳转的方法？**

`CTRL-O` goes to the older position

`CTRL-I` or tab goes to the newer on

**如何把光标定位到各种括号的匹配项？例如：找到(, [, or {对应匹配的),], or }**

位于待查找括号时 `%:`

**在不退出vim的情况下执行一个外部程序的方法？**

`:!commmand`

**如何使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法？如何在两个不同的分屏窗口中移动光标？**

内置帮助系统：`:help` 或 `<F1>` 

移动光标：`CTRL-W` 两次