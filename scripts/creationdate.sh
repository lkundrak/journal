#!/bin/sh

# Outputs a formatted date of firest revision of specified file
# Append a "\t filename" if multiple files are specified

FORMAT=$1
shift

for FILE in $*
do
	DATE="$(sed -n 's/<!-- date:\(.*\) -->/\1/p' $FILE)"
	[ "$DATE" ] || DATE="$(git log $FILE | awk '/Date:/ {gsub ("Date: *", ""); gsub ("+.*",""); d=$0} END {print d}')"
	DATE="$(date "+$FORMAT" -d "$DATE")"
	echo -n $DATE
	echo "$(echo $* |grep -q ' ' && echo -e "\t$FILE")"
done
