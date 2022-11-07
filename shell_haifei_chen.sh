#!/bin/bash
function action(){
string=$1
#echo $string
OLD_IFS="$IFS"
IFS=","
array=($string)
IFS=$OLD_IFS
mkdir "${array[1]}"
cd "${array[1]}"
mkdir "${array[2]}"
cd "${array[2]}"

# here judge if active or not
fileName="${array[3]}."
date="${array[7]}"
#echo $fileName
#echo $date
OLD_IFS="$IFS"
IFS="/"
dateArray=($date)
IFS=$OLD_IFS

#echo "Month: ${dateArray[0]}"
#echo "Year: ${dateArray[1]}"

ym="${dateArray[1]}${dateArray[0]}"
#echo $ym
if [ "${ym}" -ge "202211" ];then
	fileName="${fileName}active"
	else
	fileName="${fileName}expired"
fi

#echo $fileName
touch $fileName

echo "Card Type Code: ${array[0]}">>$fileName
echo "Card Type Full Name: ${array[1]}">>$fileName
echo "Issuing Bank: ${array[2]}">>$fileName
echo "Card Number: ${array[3]}">>$fileName
echo "Card Holder's Name: ${array[4]}">>$fileName
echo "CVV/CVV2: ${array[5]}">>$fileName
echo "Issue Date: ${array[6]}">>$fileName
echo "Expiry Date: ${array[7]}">>$fileName
echo "Billing Date: ${array[8]}">>$fileName
echo "Card PIN: ${array[9]}">>$fileName
#echo "Credit Limit: ${array[10]}"
str="${array[10]}"
str=` echo $str | sed -e 's/^[\t]*//g'`
length=`echo ${#str}`
cut_index=3
money=" USD"
while [ $length -gt $cut_index ]
do
	#echo $length
	money=",${str:0-${cut_index}:3}${money}"
	((cut_index=$cut_index+3))
done
l=0
((l=3+${length}-${cut_index}))
money="$""${str:0:${l}}${money}"
echo "Credit Limit: $money">>$fileName


cd ../..

}
var=1
while read line 
do
        #Reading each line
		if [ $var -ne 1 ];then
		#echo $var
		action "$line"
		#echo "$line"
		fi
		((var=$var+1))
done < '100 CC Records.csv'