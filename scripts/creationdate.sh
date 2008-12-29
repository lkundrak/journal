#!/bin/sh

# Outputs a formatted date of firest revision of specified file
# Append a "\t filename" if multiple files are specified

FORMAT=$1
shift

for FILE in $*
do
	echo -n $(date "+$FORMAT" -d "$(rlog $FILE |
		awk '/^date:/ {date=$2" "$3} END {gsub (";", "", date); print date}')")
	echo "$(echo $* |grep -q ' ' && echo -e "\t$FILE")"
done
