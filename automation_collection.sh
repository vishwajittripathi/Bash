#!/bin/bash
filevalue() {
export FileName="OTG_PAY_PATH.txt"
}
copy_files() {

filevalue

cat $FileName | while read next

do
echo $next
cd "$next"
for i in *
do
if [[ -f $i ]]
then
mv "${i}" '/filestorage/DESTINATION/MASTER_NACH_PAY/'
fi
done;
done;
}
main () {
copy_files
}
main
echo SUCCESS
