#!/bin/bash
exec 3>&1 4>&2 1>SCR_INPPST.log 2>&1
utilitycode=YESB000000001
shortname=karvi
Todate="$(date '+%d%m%Y')"
echo "${Todate}"
INPPATH="${HOME}/Bash/IN/"
CNVPATH="${HOME}/Bash/OUT/INP_CONVTED/"
#echo "$CNVPATH"
cd "$INPPATH"
for i in *-INP.txt
do
	if [[ -f $i ]]
	then #echo "$i is file"
		IFS=- read -r I1 I2 I3 I4 I5 I6 I7 <<< "$i"
		mv "${i}" "NACH_DR_${I5}_${utilitycode}_${shortname}_${I6}.txt"
		echo "${i}|NACH_DR_${I5}_${utilitycode}_${shortname}_${I6}.txt"
		mv NACH_DR_* "${CNVPATH}"
	fi
done
exec 1>&3 2>&4
echo >&2 "FANTAILP_SUCCESS"
