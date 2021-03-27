#!/bin/bash

FILE_LOG="/home/syamil/Downloads/syslog.log"
regex='.+: (INFO|ERROR) (.+) \((.+)\)'

declare -A ERROR 
declare -A USER_INFO
declare -A USER_ERROR

while IFS= read -r line
do
	[[ $line =~ $regex ]]
	if
	    [[ ${BASH_REMATCH[1]} == "ERROR" ]]
	then
	    ((ERROR['${BASH_REMATCH[2]}']++))
	    ((USER_ERROR['${BASH_REMATCH[3]}']++))
	else
	   ((USER_INFO['${BASH_REMATCH[3]}']++))
	fi
done < "$FILE_LOG"

for key in "${!ERROR[@]}"
do
	printf "%s,%d\n" "$key" "${ERROR[$key]}"
done | sort -rn -t, -k2 > error_message.csv

echo -e "Error,count\n$(cat error_message.csv)" > error_message.csv

for key in "${!USER_ERROR[@]}" "${!USER_INFO[@]}"
do
	printf "%s,%d,%d\n" "$key" "${USER_INFO[$key]}" "${USER_ERROR[$key]}"
done | sort -u > user_statistic.csv

echo -e "Username,INFO,ERROR\n$(cat user_statistic.csv)" > user_statistic.csv
