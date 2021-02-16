#! /bin/bash

source header.sh

echo "header.sh ip value: $ip"

new_ip=""

#save ip addr result into ip_backup
ip_backup=$(ip address)

if [ $? == 0 ] 
then
	echo "Successfully read ip addr"
else
	echo "Fail to read ip addr"
	exit 1
fi

#take the last case of string between 'inet ' and '/24 brd'
#filter right side then left side of string
new_ip=$(echo ${ip_backup##*inet } | (read line; echo ${line%%/24 brd*}))

#find the first line with "ip=" and enumerate
#split with : separator e save in array variable
IFS=':' read -r -a array <<< $(grep -n "^export ip=*" header.sh)
echo "line: ${array[0]}, data: ${array[1]}"

#Substitute line found above and save current machine ip into header.sh
$(sed -i "${array[0]}s/.*/export ip=\"${new_ip}\"/" header.sh)

echo "new value: export ip=\"${new_ip}\""
