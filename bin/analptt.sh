#!/bin/bash
filename=${1}
tmpfile=tmpfile
oldstatus=a
oldtime=a
oldip=a
oldinbox=a

if [ -z $filename ]; then
  echo 'please assign input ptt log file name'
  exit 0
fi

#txt=$(cat $filename | cut -c 34- )

txt=$(cat $filename |awk -F " " '{ print $5","$8","$9","$10","$11","}')

tmpIFS=$IFS

#IFS=$'\r\n ' 
IFS=$',\n '

read -r -a lines <<< $txt

#0: op time
#1: status
#2: time
#3: ip
#4: inbox status

for index in ${!lines[@]}
do
  if [ $((index%5)) == 0 ]; then
    optime=${lines[$index]}
    status=${lines[$index+1]}
    time=${lines[$index+2]}
    ip=${lines[$index+3]}
    inbox=${lines[$index+4]}
    
    if [ $status != $oldstatus ] || [ $time != $oldtime ] || [ $ip != $oldip ] || [ $inbox != $oldinbox ]; then
      echo $optime$'\t'$status$'\t'$inbox$'\t'$time$'\t'$ip >> $tmpfile
    fi

    oldstatus=$status
    oldtime=$time
    oldip=$ip
    oldinbox=$inbox
  fi
done

IFS=$tmpIFS

cat $tmpfile

rm $tmpfile

