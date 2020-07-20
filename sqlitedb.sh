#!/bin/bash
xmlTemp='<?xml version="1.0"?>\n<page> \n <page_url></page_url> \n'
DateTime=`(date | awk 'OFS="-" {print $2,$3,$4,$5}')`
cd ~/sqlite/
Drop_table () {
sqlite3 htmlPage.sqlite <<EOF
DROP table htmlPage;
EOF
}
Drop_table
create_htmlPage_db() {
cd ~/sqlite/ && sqlite3 htmlPage.sqlite <<EOF
create table htmlPage (
id INTEGER PRIMARY KEY AUTOINCREMENT,
page_time text,
page_author text,
page_name text
);
EOF
}
create_htmlPage_db
update_values_in_htmlPagedb_table() {
cd ~/sqlite/ && sqlite3 htmlPage.sqlite  <<EOF
insert into htmlPage (page_time, page_author, page_name) values ('$var1','$var2','$var3');
EOF
}
cd ~/www/
v=$(ls -lrtp --time-style=full-iso | grep -v /  | wc -l)
s=$(( v - 1))
DirFileListInXml=$(ls -lrtp --time-style=full-iso | grep -v / | head -n $v | tail -n $s | awk -v var="$xmlTemp"  '
BEGIN  {printf var} {print "<id>"} {print $7} {print "</id>"}  {print "<page_author>"} {print $3} {print "</page_author>"} {print "<page_name>"} {print $NF} {print "</page_name>"} END {print "</page>"}')
echo "$DirFileListInXml" > ~/script/archive/htmlPage_$DateTime.xml
DirFilelistInTxt=$(ls -lrtp --time-style=full-iso | grep -v / | head -n $v | tail -n $s | awk 'OFS="," {print $7,$3,$9}')
echo "$DirFilelistInTxt" > ~/script/archive/htmlPage_$DateTime.txt
export data="/home/vishwajit/script/archive/htmlPage_$DateTime.txt"
count=0;
cat $data | while read next
do 
i=$(cat $data | wc -l) 
for  j in $i
do
var1=$(echo $next | cut -f 1 -d ',')
var2=$(echo $next | cut -f 2 -d ',')
var3=$(echo $next | cut -f 3 -d ',')
echo "$var1" 
echo "$var2"
echo "$var3"
update_values_in_htmlPagedb_table
done
#xml contain read by use xmlstarlet to pass in value to insert in DB
#page_id=$(xmlstarlet sel -t -v //page/id ~/script/archive/htmlPage_$DateTime.xml)
#page_author=$(xmlstarlet sel -t -v //page/page_author ~/script/archive/htmlPage_$DateTime.xml)
#page_name=$(xmlstarlet sel -t -v //page/page_name ~/script/archive/htmlPage_$DateTime.xml)
#echo "$page_id$page_author $page_name"

done

echo "####end####"
