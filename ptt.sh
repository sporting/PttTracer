#!/bin/bash

export OWNER=[OWNER_NAME]
export PTT_ID=[PTT_ACCOUNT]
export PTT_PWD=[PTT_PASSWORD]
export QUERY_ID=[PTT_QUERY_ACCOUNT]

export OWNER_HOME=/home/$OWNER

export HOME_SHELL_DIR=$OWNER_HOME/expectptt/
export HOME_SHELL_LOG_DIR=$HOME_SHELL_DIR/log
export LOG_FILE=$HOME_SHELL_LOG_DIR/ptt.log
export LOG_FILE_UTF8=$HOME_SHELL_LOG_DIR/ptt_utf8.log
export LOG_LOGING=$HOME_SHELL_LOG_DIR/ptt_login.log
export ANALYZE_DAILY_LOG=$HOME_SHELL_LOG_DIR/daily
export LOG_FILE_BACK_DIR=$HOME_SHELL_LOG_DIR/backfile/

export HOME_SHELL_BIN_DIR=$HOME_SHELL_DIR/bin
export SRC_FILE=$HOME_SHELL_BIN_DIR/pttLoopQuery
export SRC_BIG5_FILE=$HOME_SHELL_BIN_DIR/pttLoopQuery_big5
export ANALYZE_LOG_SHELL=$HOME_SHELL_BIN_DIR/analptt.sh

export LANG=zh_TW.BIG5

#check log directory exists
if [ ! -d "$HOME_SHELL_LOG_DIR" ]; then
  mkdir $HOME_SHELL_LOG_DIR
fi

#check telnet ptt.cc process exists
running=$(ps -ef|grep 'telnet ptt.cc'|grep 'grep' --invert)
if [ ! -z "${running}" ]; then
  exit 0
fi

iconv -f UTF-8 -t BIG5 $SRC_FILE -o $SRC_BIG5_FILE

expect $SRC_BIG5_FILE

iconv -f BIG5 -t UTF-8 $LOG_FILE -o $LOG_FILE_UTF8

loginTime=$(cat $LOG_FILE_UTF8 |grep --text 上次上站 | awk -F " " '{print $2}')

loginIp=$(cat $LOG_FILE_UTF8 |grep   --text 上次故鄉 |awk -F " " '{print $4}'|cut -c 19-)

loginStatus=$(cat $LOG_FILE_UTF8 |grep --text 目前動態 |awk -F " " '{print $1}'|cut -c 26-)

loginEmail=$(cat $LOG_FILE_UTF8 |grep --text 私人信箱 |awk -F " " '{print $2}'|cut -c 22-)
d=$(date)

IFS=$'\r\n '

read -r -a loginTimeAry <<<  $loginTime

read -r -a loginIpAry <<< $loginIp

read -r -a loginStatusAry <<< $loginStatus

read -r -a loginEmailAry <<< $loginEmail

# IFS is global variable, you should be recover it
IFS=$'\t'

if [ -n "$loginTime" ]; then
  for index in "${!loginTimeAry[@]}"
  do
    echo $index"  "$d"  "${loginStatusAry[index]}"  "${loginTimeAry[index]}"  "${loginIpAry[index]}"  "${loginEmailAry[index]} >> $LOG_LOGING
  done
fi

t=$(date +"%Y%m%d")

p=$LOG_FILE_BACK_DIR
p=$p"ptt_login_"$t.log

cat $LOG_LOGING >> $p

chown $OWNER:$OWNER $p

# analyze daily log
$ANALYZE_LOG_SHELL $p > $ANALYZE_DAILY_LOG/$t

chown $OWNER:$OWNER $ANALYZE_DAILY_LOG/$t

rm $LOG_LOGING

export LANG=zh_TW.UTF-8
