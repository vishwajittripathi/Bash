#!/bin/bash
xmlTemp='<?xml version="1.0"?>\n<page> \n <page_url></page_url> \n'
DateTime=`(date | awk 'OFS="-" {print $2,$3,$4,$5}')`
cd ~/sqlite/
Drop_table () {
sqlite3 htmlPage.sqlite <<EOF
DROP table htmlPage;
EOF
}
#Drop_table
create_htmlPage_db() {
cd ~/sqlite/ && sqlite3 htmlPage.sqlite <<EOF
create table htmlPage (
id INTEGER PRIMARY KEY AUTOINCREMENT,
page_time real,
page_author text,
page_name text,
page_md5  real,
page_contain blob
);
EOF
}
#create_htmlPage_db

Insert_values_in_htmlPagedb_table() {
cd ~/sqlite/ && sqlite3 htmlPage.sqlite  <<EOF
insert into htmlPage (page_time, page_author, page_name, page_md5, page_contain) values ('$page_time','$page_author','$page_name','$page_md5','$page_contain');
EOF
}

Update_values_in_htmlPagedb_table() {
cd ~/sqlite/ && sqlite3 htmlPage.sqlite  <<EOF
update htmlPage SET page_md5='$page_md5',page_contain='$page_contain' where page_name='$page_name';
EOF
}

SelectQuery() {
cd ~/sqlite/ && sqlite3 htmlPage.sqlite << EOF

select page_name,page_md5 from htmlPage where page_name='$page_name'; 

EOF
}
cd ~/www/
v=$(ls -lrtp --time-style=full-iso | grep -v /  | wc -l)
s=$(( v - 1))
ListCmd=$(ls -lrtp --time-style=full-iso | grep -v / | head -n $v | tail -n $s)
#DirFileListInXml=$(echo "$ListCmd" | awk -v var="$xmlTemp"'
#BEGIN  {printf var} {print "<id>"} {print $7} {print "</id>"}  {print "<page_author>"} {print $3} {print "</page_author>"} {print "<page_name>"} {print $NF} {print "</page_name>"} END {print "</page>"}')
#echo "$DirFileListInXml" > ~/script/archive/htmlPage_$DateTime.xml
#DirFileListInTxt=$( echo "$ListCmd" | awk '{print $6$7,$3,$9}')
DirFileListInTxtWithMD5=$(echo "$ListCmd" | awk 'BEGIN{OFS=","}{ cmd= " md5sum " $9 ; cmd|getline md5;close(cmd);} {print $6$7,$3,$9,md5}')
echo "$DirFileListInTxtWithMD5" | awk 'BEGIN{OFS=","}{sub("",s);print $1}' > ~/script/archive/DirList_$DateTime.txt
export data="/home/vishwajit/script/archive/DirList_$DateTime.txt"
cat $data | while read next
do 
i=$(cat $data | wc -l) 
for  j in $i
do
cd ~/www/
page_time=$(echo $next | cut -f 1 -d ',')
page_author=$(echo $next | cut -f 2 -d ',')
page_name=$(echo $next | cut -f 3 -d ',')
page_md5=$(echo $next | cut -f 4 -d ',')
page_contain=$(cat "$page_name")
sqlData=$(SelectQuery)
sqlData_Page_Name=$(echo "$sqlData" | cut -f 1 -d '|')
sqlData_md5=$(echo "$sqlData" | cut -f 2 -d '|')
#echo "$sqlData_Name"
#echo "$sqlData_md5"
#echo "$page_time" 
#echo "$page_author"
#echo "$page_name"
#echo "$page_md5"
#echo "$page_contain"
if [ "$page_name" != "$sqlData_Page_Name" ] && [ "$page_md5" != "$sqlData_md5" ]
then 
echo "Need to call Insert"
Insert_values_in_htmlPagedb_table
if [ "$page_name" == "$sqlData_Page_Name" ] && [ "$page_md5" != "$sqlData_md5" ]
then
echo "Need to call Update"
Update_values_in_htmlPagedb_table
fi
fi
done
done
echo "No chnage in data :-)"
#curl -F apikey="" -F dbowner="vishwajittripathi" -F dbname="htmlPage.sqlite" -F sql="c2VsZWN0ICogZnJvbSBodG1scGFnZTs=" https://api.dbhub.io/v1/query
#xml contain read by use xmlstarlet to pass in value to insert in DB
#page_id=$(xmlstarlet sel -t -v //page/id ~/script/archive/htmlPage_$DateTime.xml)
#page_author=$(xmlstarlet sel -t -v //page/page_author ~/script/archive/htmlPage_$DateTime.xml)
#page_name=$(xmlstarlet sel -t -v //page/page_name ~/script/archive/htmlPage_$DateTime.xml)
#done
#echo "####end####"
