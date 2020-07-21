#!/bin/bash
cd ~
DirTime=$(ls -ldrt --time-style=full-iso www | awk '{print $7}')
Pre60Sec=$(echo "$DirTime")
echo "$Pre60Sec"
count=0;
while [ $count != 60 ]
do
sleep 1
((count++))
#echo "$count"
done
Post60Sec=$(echo "$DirTime")
echo "$Post60Sec"
if [ "$Pre60Sec" != "$Post60Sec" ]
then
echo "need to execute sqlitedb.sh"
else 
echo "Directory Not Change :-)"
fi
