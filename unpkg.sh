#!/bin/sh
# 用于解压缩
# 使用例子是：
# ./unpkg.sh -p *****.****
# 参数:-p 后面跟压缩包
#
#
# 或者直接后面跟名字
# ./unpkg.sh  *****.****
#
# author：Kevin
# create: 2020-12-17 11:10:27
#
#
B_DEBUG=0
PKG_NAME=""
B_HAVE_P=0	# 是否有-p


#遍历参数
for((i=1;i<=$#;i++));do
	
	param_value=$(eval echo \${${i}})
	#echo "param${i} : ${param_value}"
	if [ "$param_value" = "-p" ]
	then
	
		i_1=`expr $i + 1`;
		PKG_NAME=$(eval echo \${${i_1}});
		B_HAVE_P=1
		
	elif [ "$param_value" = "-d" ];then
		B_DEBUG=1
		#echo "using debug"
	fi
done


if [ $B_HAVE_P = 0 ];then
	PKG_NAME=$1
fi


#echo "PKG_NAME = ${PKG_NAME}"

# 检测
if [ "$PKG_NAME" = "" ] ; then
	echo "Error : program name is invalid,name is empty . use -p."
	exit 3
fi

# 确定文件的格式,从最复杂的方式开始匹配
FILE_FMT=""
CMD=""

while true
do

# 做最大匹配
FILE_FMT=${PKG_NAME%%*.tar.gz}
if [ "$FILE_FMT" != "$PKG_NAME"  ] ; then
		echo "the file format is: *.tar.gz"
		CMD="tar -xzf "
		break
fi

FILE_FMT=${PKG_NAME%%*.gz}
if [ "$FILE_FMT" != "$PKG_NAME"  ] ; then
		echo "the file format is: *.gz"
		CMD="gunzip "
		break
fi


FILE_FMT=${PKG_NAME%%*.zip}
if [ "$FILE_FMT" != "$PKG_NAME"  ] ; then
		echo "the file format is: *.zip"
		CMD="unzip "
		break
fi

FILE_FMT=${PKG_NAME%%*.tar.bz2}
if [ "$FILE_FMT" != "$PKG_NAME"  ] ; then
		echo "the file format is: *.tar.bz2"
		CMD="tar -xjf "
		break
fi

FILE_FMT=${PKG_NAME%%*.tar.Z}
if [ "$FILE_FMT" != "$PKG_NAME"  ] ; then
		echo "the file format is: *.tar.Z"
		CMD="tar -xZf "
		break
fi

FILE_FMT=${PKG_NAME%%*.Z}
if [ "$FILE_FMT" != "$PKG_NAME"  ] ; then
		echo "the file format is: *.Z"
		CMD="uncompress "
		break
fi

FILE_FMT=${PKG_NAME%%*.rar}
if [ "$FILE_FMT" != "$PKG_NAME"  ] ; then
		echo "the file format is: *.rar"
		CMD="unrar e "
		break
fi



FILE_FMT=${PKG_NAME%%*.tar}
if [ "$FILE_FMT" != "$PKG_NAME"  ] ; then
		echo "the file format is: *.tar"
		CMD="tar -xvf "
		break
fi


break
done

if [ "$CMD" = "" ];then
	echo "Error : unsurported compressed file : $PKG_NAME"
	exit 1
fi


# 开始运行
echo "start unpackage : $CMD $PKG_NAME"

$CMD $PKG_NAME

if [ $? != 0  ] ; then
	echo "unpackage faild!"
	exit 2
fi


echo "unpackage end"
echo "if you have problem,please e-mail Kevin_Txy@163.com."
