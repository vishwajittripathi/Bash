#!/bin/bash
echo "Start"
cp /dev/null scan_report.txt
nmap -sV -p 22 192.168.1.0/24 | while read  num
do
	#counter=`nmap -sV -p 22 192.168.1.0/24 | wc -l | cut -d " " -f1`	
	#echo "$counter"
	for word in $num;
		do 
			#echo "$counter"
			#var1=$(echo "$num" | awk '{print $5}')
		       if [[ "$word" == "report" ]] || [[ "$word" == "ssh" ]]; 
		       then
			echo "$num" | awk '{print $2, $3, $5}' >> scan_report.txt
			#var1=$(echo "$num" | awk '{print $5}')
			var2=$(echo "$num" | awk '{print $2}')
			if [[ "$var2" == "open" ]];
			then
				iptoConnect=$(awk -v N=1 -v pattern="open" '{i=(1+(i%N));if (buffer[i]&& $0 ~ pattern) print buffer[i]; buffer[i]=$0;}' scan_report.txt | awk {'print $3'})
			#sed '1N; $!N; /.*\n.*\n.*open/P; D' scan_report.txt
			echo "#ssh vishwajit@$iptoConnect"

			fi
		       fi
		done
#	sleep 5

done
