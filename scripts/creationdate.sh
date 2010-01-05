#!/bin/sh

# Outputs a formatted date of firest revision of specified file
# Append a "\t filename" if multiple files are specified

FORMAT=$1
shift

for FILE in $*
do
	echo -n $(date "+$FORMAT" -d "$(git log $FILE |
		awk '/Date:/ {gsub ("Date: *", ""); gsub ("+.*",""); d=$0} END {print d}')")
	echo "$(echo $* |grep -q ' ' && echo -e "\t$FILE")"
done
