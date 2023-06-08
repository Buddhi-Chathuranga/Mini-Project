#!/bin/bash

help_args ()
{
echo
echo
echo Usage: create-multi-delivery.sh mergeType="<type>" deliveryPath="<path>" deliveryDestPath="<path>"
echo
echo "      mergeType          maintem or mergetem."
echo "                         - maintem:  The database folder in each single delivery will be copied to database folder as a subfolder, named as the single delivery and a new " 
echo "                                     install.tem (master install.tem) will be created, calling these single deliveries install.tem in the defined copy order."
echo "                         - mergetem: The database sub folders will be copied in sequence and the files calling these single files in the subfolders will be regenerated," 
echo "                                     as well as the tem files (e.g. install.tem) and install.ini file."
echo "      deliveryPath       Path to the folder containing the single deliveries."
echo "      deliveryDestPath   Path to the created merged delivery."
echo
exit 1
}

if [[ $1 == "?" ]] || [[ $1 == "/?" ]] || [[ $1 == "--help" ]] || [[ $1 == "/help" ]]; then	
	help_args 
fi
pushd `dirname $0`
LIB="$(dirname $(pwd))/lib"
CLASSPATH=$LIB/ifs-fnd-dbbuild.jar:$LIB/snakeyaml-1.26.jar

java -cp $CLASSPATH -Duser.language=en -Duser.country=US ifs.fnd.dbbuild.CreateMultiDelivery "$@"
popd
