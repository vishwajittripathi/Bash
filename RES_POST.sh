#!/bin/bash
exec 3>&1 4>&2 1>>SCR_RESPST.log 2>&1
utilitycode=YESB000000001
shortname=karvi
Todate="$(date '+%d-%m-%Y')"
echo "${Todate}"
INPPATH="${HOME}/Bash/IN/"
CNVPATH="${HOME}/Bash//RES_CONVTED/"
#echo "$CNVPATH"
cd "$INPPATH"
if [ -z "$(ls -A $INPPATH)" ]; then
       echo "$INPPATH is Empty"
	echo "FANTAILP_SUCCESS"
else
cd "$INPPATH"	
find . -type f -name '*-YESB-*-RES*' | while read FILE ; do
newfile="$(echo "$FILE" |sed -e 's/\-//g')" ;
mv "$FILE" "$newfile" ;
mv "$newfile" "${CNVPATH}"
echo "${FILE}|${newfile}"
#for i in *-YESB-*-RES*
#do
#	if [[ -f $i ]]
#	then echo "$i is file"
#		newfile=$(sed 's/\-//g' ${i})
#		#IFS=- read -r I1 I2 I3 I4 I5 I6 I7 <<< "$i"
#		#mv "${i}" "NACH_DR_${I5}_${utilitycode}_${shortname}_${I6}.txt"
#		#echo "${i}|NACH_DR_${I5}_${utilitycode}_${shortname}_${I6}.txt"
#		#mv NACH_DR_* "${CNVPATH}"
#		echo "$newfile"
done
	fi
exec 1>&3 2>&4
echo >&2 "FANTAILP_SUCCESS"
