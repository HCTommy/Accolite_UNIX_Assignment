#!/bin/bash
function read_each_file(){
filepath=$1
#echo "${filepath}"
var=1
str=""
while read line 
do
        #Reading each line
		OLD_IFS="$IFS"
		IFS=":"
		array=($line)
		IFS=$OLD_IFS
		if [ $var -ne 11 ];then
		#echo "$line"
		temp="${array[1]}"
		temp=` echo $temp | sed -e 's/^[\t]*//g'`
		str="${str}${temp},"
		elif [ $var -eq 11 ]
		then
		temp="${array[1]}"
		temp=` echo $temp | sed -e 's/^[\t]*//g'`
		OLD_IFS="$IFS"
		IFS=" "
		array2=($temp)
		IFS=$OLD_IFS
		temp="${array2[0]}"
		temp=${temp:1}
		OLD_IFS="$IFS"
		IFS=","
		array3=($temp)
		IFS=$OLD_IFS
		for element in ${array3[*]}
		do
		str="${str}${element}"
		done
		fi
		((var=$var+1))
done < "${filepath}"
echo ${str}
echo "${str}">>consolidated.csv

}

function dir_list(){
for file in "$1"/*
do
if [ -d "${file}" ];
then
dir_list "${file}"
elif [ -f "${file}" ]
then
if [ ${file:0-7:7} = ".active" -o ${file:0-8:8} = ".expired" ];
then
#echo "${file}"
read_each_file "${file}"
fi
fi
done
}

touch consolidated.csv
echo "Card Type Code,Card Type Full Name,Issuing Bank,Card Number,Card Holder's Name,CVV/CVV2,Issue Date,Expiry Date,Billing Date,Card PIN,Credit Limit">>consolidated.csv
dir_list "."