#!/bin/bash
#gxnuwrt.sh是一个openwrt系统用的sh脚本，用以路由器自动登录校园网。
#食用方法：首先你需要一个有OpenWrt系统的路由器，且剩余空间应大于3MB
#1、按照下方说明输入参数，共3个参数，完成后保存文件
#2、保存文件后，把文件上传到路由器，传文件教程百度搜索：WinSCP如何登陆路由器-百度经验。把脚本放到/root目录。
#3、上传完毕，按Shift+Ctrl+T打开WinSCP的终端，输入该命令：sed -i 's/exit 0/sh \/root\/gxnuwrt.sh \&\nexit 0/' /etc/rc.local
#4、点击执行后，关闭窗口，重启路由器。这样，路由器每次开机就会启动脚本，当网络断开时会自动尝试重连。
#5、若要停用脚本，则打开终端输入：sed -i 's/sh \/root\/gxnuwrt.sh \&//' /etc/rc.local  
#6、点击执行后，关闭窗口，重启路由器即可。

#可能需要关闭自服务系统中的无感知功能

#-------------------参数设置区域开始分界线-------------------
#双引号内填入上网账号，即学号
ID="**********"

#双引号内填入上网密码
PASSWORD="******"

#双引号内填入运营商代码
#移动：cmcc
#电信：telecom
#联通：unicom
#校园网留空
WEB_PROVIDER="telecom"

#登录设备类型：0为PC，1为移动设备
Device_type="0"
#-------------------参数设置区域开始分界线-------------------



#-------------------下方为代码区，无需改动-------------------

Login()#登录函数，参数依次为：账号、密码、运营商
{
    wget -qO- "http://210.29.79.141:801/eportal/?c=ACSetting&a=Login&DDDDD=,${Device_type},${ID}@${WEB_PROVIDER}&upass=${PASSWORD}" &> /dev/null
}

Logout()#注销函数
{
    wget -qO- "http://210.29.79.141:801/eportal/?c=Portal&a=logout" &> /dev/null
}

#表示当前账号，0表示未登录账号，1表示登录本科生账号，2表示登录研究生账号
Account=0
#日志计数
count="10000"
#运行程序前清空日志
echo "#" >/root/ping.log

#设置死循环
while true;do
    #测速日志计数+1
    let count++
    
    #获取登录页状态检测账号是否登录
    wget -q -O /root/temp "http://210.29.79.141"
    grep -q "COMWebLoginID_0" /root/temp
    #若未登录则把登录账户设为空，用于重连
    if [ $? == 0 ];then
        ifup wan
        Account=0
        sleep 10
    fi
    echo -e "\n$(date +%Y-%m-%d) $(date +%H:%M:%S) Account: ${Account} ------------------------${count:1}" >/root/temp
    #时间倒序输出结果
    sed -i '/#/r /root/temp' /root/ping.log

    if [ $Account -ne 1 ];then
        Logout
        sleep 5
        Account=1
        Login
        echo -e "\n\nLogin Account 1" >/root/temp
        #时间倒序输出结果
        sed -i '/#/r /root/temp' /root/ping.log
    fi

    #当断网检测2000次时清空日志
    if [ $count -ge 12000 ];then
        echo "#" >/root/ping.log
        count="10000"
    fi

    #间隔120s再次检测网络是否连通
    sleep 120

done