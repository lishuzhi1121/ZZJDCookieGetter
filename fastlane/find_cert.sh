#!/bin/bash

function help() {
    echo "Usage: find_cert <team id>"
    exit 1
}

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options
if [ "$VALID_ARGUMENTS" -ne 1 ]; then
  help
fi

team_id=$1
team_id_len=${#team_id}
if [[ $team_id_len -lt 3 ]]; then
	help
fi

# 获取钥匙所有证书信息
certs=$(security find-identity -p codesigning)
# 去除无效内容
certs=${certs#*'Matching identities'}
certs=${certs%%'Valid identities only'*}
# 删除开头空白行
certs=$(echo "$certs" | sed 1d)
# 删除末尾空白
certs=$(echo "$certs" | sed 's/[ ]*$//g')
# 处理有效行数
line_counts=$(( $(echo "$certs" | wc -l) - 1 ))
# echo $line_counts
certs=$(echo "$certs" | head -n $line_counts)
certs=$(echo "$certs" | sed -r 's/.*"(.*)".*/\1/g')
# echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
# echo "$certs"
# echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

OLD_IFS=$IFS
IFS=$'\n'
certs_list=($certs)
target_cert_name=""
for cert_name in ${certs_list[*]}; do
	if [[ $cert_name =~ ^"Developer ID Application".* && $cert_name =~ $team_id ]]; then
		target_cert_name=$cert_name
	fi
done
IFS=$OLD_IFS

echo $target_cert_name


