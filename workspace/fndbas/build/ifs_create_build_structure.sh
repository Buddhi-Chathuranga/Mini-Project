#!/bin/bash

_all_args="$@"
_script=`realpath $0`
_script_path=`dirname $_script`
_script_name=${0##*/}
pushd $_script_path > /dev/null
# name of the script
_ifs_mtcbs="create build structure"
echo "IFS Cloud Applications - ${_ifs_mtcbs}"
unset _COMPONENTS
unset _DELIVERY

while [ "$1" != "" ]; do
    case $1 in
		# components folder defined
	    --components )
		 	shift
			_COMPONENTS=$1
		;;
		# delivery folder defined
	    --delivery )
		 	shift
			_DELIVERY=$1
		;;	
    esac
    shift
done

# ifs_create_build_structure.sh in gitcheckout?
if [ -n "$_COMPONENTS" ]; then
  if [ -f $_COMPONENTS/fndbas/build/$_script_name ]; then 	
    if ! (cmp -s $_COMPONENTS/fndbas/build/$_script_name  $_script_path/$_script_name);then 
      echo `date` $_script_name exists in $_COMPONENTS. Copy new version and restart...
      echo cp $_COMPONENTS/fndbas/build/$_script_name $_script_path/$_script_name \& bash $_script_path/$_script_name $_all_args 
      cp $_COMPONENTS/fndbas/build/$_script_name $_script_path/$_script_name && bash $_script_path/$_script_name $_all_args && exit 
    fi
  fi
fi

echo "Preparing ${_ifs_mtcbs} tools..."
bash ../ifsinstaller/utils/verify_required_software.sh --jdk
if ! [ $? -eq 0 ]; then
	popd > /dev/null
	exit 1
fi
# compile and package in a temp folder
_workspace=`mktemp -d`
# check if tmp dir was created
if [ ! -d "$_workspace" ]; then
	echo "Could not create temporary folder."
	popd > /dev/null
	exit 1
fi
# copy the source files from component-struct.
_mtcbs_src=${_script_path%/*}
rsync -rq --progress ${_mtcbs_src}/source/fndbas/mtcbs/src/ ${_workspace}/src/
if [ -n "$_COMPONENTS" ]; then
  if [ -d $_COMPONENTS/fndbas/source/fndbas/mtcbs/src ]; then 
	rsync -rq --progress $_COMPONENTS/fndbas/source/fndbas/mtcbs/src/ ${_workspace}/src/
	if [ -n "$_DELIVERY" ]; then 
	  rsync -rq --progress $_COMPONENTS/fndbas/source/fndbas/mtcbs/src/ ${_mtcbs_src}/source/fndbas/mtcbs/src/
    fi
  fi
fi
# java compile
javac -d $_workspace/binx -sourcepath ${_workspace}/src ${_workspace}/src/ifs/cloud/build/Builder.java
res=$?
if [ $res -ne 0 ]; then
	echo "Compilation error found in ${_ifs_mtcbs} tools."
	popd > /dev/null
	exit 1
fi
# jar package
jar --create --main-class ifs.cloud.build.Builder --file ${_workspace}/_ifs_mtcbs.jar -C ${_workspace}/binx .
res=$?
rm -r ${_workspace}/binx
rm -r ${_workspace}/src
if [ $res -ne 0 ]; then
	echo "Error packaging ${_ifs_mtcbs} tools."
	popd > /dev/null
	exit 1
fi
# Java exec
java -jar ${_workspace}/_ifs_mtcbs.jar create $_all_args
popd > /dev/null
exit $?