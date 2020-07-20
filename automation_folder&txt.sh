#clear all
#!/bin/bash/
if [ "$1" == null ] || [ "$2" == null ] || [ -z "$1" ] || [ -z "$2" ]
then
echo "Corporate Name or utility code should not empty"
else
#if [[ "$1" =~ ^[[:alnum:]]{4,10}$ ]] && [[ "$2" =~ ^[[:digit:]]{4}+$ ]]
#then
echo "corporatename:$1"
echo "utlitycode:$2"
cp /secureapp/SETUP/bin/NACH_*_PATH.txt /secureapp/SETUP/NACH_MAPPING/
cp /secureapp/SETUP/bin/OTG_PAY_PATH.txt /secureapp/SETUP/NACH_MAPPING/
cd /filestorage/DESTINATION/
eval "mkdir -p $1/{dir1,dir2,dir3}"
echo folder for $1 created
vartime=$(date +"%Y%m%d")
cd /secureapp/SETUP/NACH_MAPPING/
cp NACH_PAY_PATH.{txt,"$vartime".txt}
cp NACH_RES_PATH.{txt,"$vartime".txt}
cp OTG_PAY_PATH.{txt,"$vartime".txt}
#echo "corpname:$1"
#echo "utlitycode:$2"
exec > NACH_PAY_PATH_NEW.txt
cat NACH_PAY_PATH.txt | sort | uniq
echo "$2:/expapp_ach/FANTAIL/CORPORATE/$2/IN/"
exec > NACH_RES_PATH_NEW.txt
cat NACH_RES_PATH.txt | sort | uniq
echo "/expapp_ach/CORPORATE/$2/IN/"
echo "/expapp_ach/CORPORATE/$2/OUT/"
exec > OTG_PAY_PATH_NEW.txt
cat OTG_PAY_PATH.txt | sort | uniq
echo "/filestorage/DESTINATION/$1/NACH_DR/"
#exit
mv NACH_{PAY_PATH_NEW.txt,PAY_PATH.txt}
mv NACH_{RES_PATH_NEW.txt,RES_PATH.txt}
mv OTG_{PAY_PATH_NEW.txt,PAY_PATH.txt}
cp ./NACH_*_PATH.txt /secureapp/SETUP/bin/
cp ./OTG_PAY_PATH.txt /secureapp/SETUP/bin/
fi
