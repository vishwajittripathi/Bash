#!/bin/bash
cd /ach/MASTER_PAY/
pwd
for i in *
do
if [[ -f $i ]]
then echo "$i is file"
IFS=_ read -r F1 F2 F3 F4 F5 F6 <<< "$i"
export FileName="/setup/windows/bin/NACH_PAY_PATH.txt"
cat $FileName | while read next
do
cff=$(echo $next | cut -f 1 -d ':')
ucp=$(echo $next | cut -f 2 -d ':')
if [[ "${F5}" == "${cff}" ]]
then mv "${i}" "${ucp}"
fi
done
fi
done
echo SUCCESS
