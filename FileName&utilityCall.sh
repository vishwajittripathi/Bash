#!/bin/sh
inpath="path1"
encpath="path2"
arhpath="path3"
enchpath="path4"
if [ -z "$(ls -A $inpath)" ]; then
echo "$inpath is Empty"
echo "SUCCESS"
else
cd "$inpath"
find . -type f -name 'corp*.*' | while read FILE ; do
newfile="$(echo "$FILE" |sed -e 's/\_//g')" ;
mv "$FILE" "$newfile" ;
done
cd "$inpath"
for ftoen in *.*;do
cd "$enchpath"
java -jar utlity.jar "$inpath$ftoen" "$encpath$ftoen.enc" "$arhpath$ftoen.crc"
cd "$encpath"
cp "$ftoen.enc" "$arhpath"
cd $inpath
echo "$ftoen"
rm "$ftoen"
echo SUCCESS
done
fi
