#!/bin/bash

function help_file
{
       echo "-c        将png/svg图片统一转换为jpg格式图片" 
       echo "-q        对jpeg格式图片进行图片质量压缩"
       echo "-s        对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率"
       echo "-a        对图片批量添加自定义文本水印"
       echo "-r        批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名"
}
#将png/svg图片统一转换为jpg格式图片 
function png/svg_change_to_jpg()
{
       for f in $(find ./images -iname "*.*"); do
              i=${f*.}
              echo $i
              if [[ $i == "png"||$i == "svg" ]];then
                     convert $f ${f%.*}.jpg
                     echo ${f%.*}.jpg
              fi
       done
}
#对jpeg格式图片进行图片质量压缩(以75%为例)
function jpg_quality_compresion()
{      
       for f in $(find ./images -iname "*.*"); do
              i=${f*.}
              if [[ $i == "jpg" ]];then
                     convert -quality 75 $f ${f%.*}-compression.jpg
                     echo ${f%.*}-compression.jpg 
              fi
       done
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function jpg/png/svg_resize()
{
       for f in $(find ./images -iname "*.*"); do
              i=${f*.}
              if [[ $i == "png"||$i == "svg"||$i == "jpg" ]];then
                     convert -resize 10000@ $f ${f%.*}-resize.$i #按比例调整图片至面>积最靠近10000
                     echo ${f%.*}-resize.$i
              fi
       done
}

#对图片批量添加自定义文本水印
function add_watermark()
{
       for f in $(find ./images -iname "*.*"); do
              i=${f*.}
              convert $f -gravity center -fill black -pointsize 16 -draw "text 5,5 'watermark'" ${f%.*}-watermark.$i #将watermark字样水印添加到图片中央
              echo ${f%.*}-watermark.$i
       done
}

#批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
function rename()
{
       for f in $(find ./images -iname "*.*"); do
              i=${f*.}
              mv $f ${f%/*}/-rename-${f*/*/} #前缀
              echo ${f%/*}/-rename-${f*/*/}
              mv $f ${f%.*}-rename-.$i #后缀
              echo ${f%.*}-rename-.$i
       done
}

read -p "请输入命令:" command_1
case "$command_1" in
       -c)
              png/svg_change_to_jpg
              ;;
       -q)
              jpg_quality_compresion
              ;;
       -s)
              jpg/png/svg_resize
              ;;
       -a)
              add_watermark
              ;;
       -r)
              rename
              ;;
       -h)     
              help_file
              ;;
esac

