#!/bin/bash

_all_args="$@"
_user_pass=0
_delivery=
_workspace=
_full_path=$(realpath $0)
_build_home="$(dirname $(dirname "${_full_path}"))"
while [ "$1" != "" ]; do
    case $1 in
		# jfrog user id ex: --user jfrog_ifs_user
		--user )
			_user_pass=$((_user_pass + 1))
		;;
		# jfrog password ex: --password jfrog1234
		--password )
            _user_pass=$((_user_pass + 1))
        ;;
		# folder containing delivery strcuture ex: --delivery c:\ifs\del01
		--delivery )
		 	shift
			_delivery=$1
		;;
		# folder containing build home strcuture ex: --delivery c:\ifs\build-home
		--build-home )
		 	shift
			_build_home=$1
		;;
		# internal - will only be set by the script when an update is found
		--workspace )
		 	shift
			_workspace=$1
		;;
    esac
    shift
done
if [ $_user_pass -ne 2 ]; then
	echo "Argument error."
	echo ""
	echo "Usage:"
	echo "ifs_fetch --user user-id --password password [other-options]"
	echo "user-id:  jfrog repo user"
	echo "password: password for user-id"
	echo "other-options:"
	echo "--build-home path      folder path to the build home - default is one level up from current"
	echo "--delivery path        folder path to the delivery - no default, fetch run in fresh home mode"
	echo "--force-download flag  force downloading archives even if they are not modified - flag is one of true or false"
	echo "--host host-name       host name for jfrog artifactory - default is ifscloud.jfrog.io"
	echo "                       NOTE: for DEV provide a host with dev artifacts"
	echo "--log-level level      log level is one of OFF, SEVERE, WARNING, INFO, CONFIG, FINE, FINER, FINEST, ALL"
	echo "--repo-name repo-name  repo-name of the jfrog artifactory - default binaryartifacts"
	echo ""
	exit 1
fi
bash ../ifsinstaller/utils/verify_required_software.sh --jdk
if ! [ $? -eq 0 ]; then
    exit 1
fi
_src_path=${_build_home}/source/fndbas/fetch/src
_work_dir=`mktemp -d`
# check if tmp dir was created
if [ ! -d "$_work_dir" ]; then
  echo "$(date) Could not create temporary folder."
  exit 1
fi
if [ -z "${_workspace}" ]; then
	# still in script in build_home
	cp -r ${_src_path} ${_work_dir}/src
else 
	_work_dir=${_workspace}
fi
if [ ! -z "${_delivery}" ]; then
	# in delivery mode
	if [ -d ${_delivery} ]; then
		if [ -z "${_workspace}" ]; then
			# still in script in build_home
			_script=${_delivery}/build/ifs_fetch.sh
			if [ -f "${_script}" ]; then
				echo "$(date) Updated ifs_fetch script available. Switching..."
				# run the updated script in delivery
				bash ${_script} ${_all_args} --build-home ${_build_home} --workspace ${_work_dir}
				exit $?
			fi
		fi
		_updated_src=${_delivery}/source/fndbas/fetch/src
		if [ -d ${_updated_src} ]; then
			echo "$(date) Updated ifs_fetch available. Copying..."
			cp -r ${_updated_src} ${_work_dir}/src
		fi
		# fecth will run in delivery folder
		_build_home=${_delivery}
		_extra_args=--ignore-cache
	fi
fi
echo "$(date) Compiling ifs_fetch tool..."
javac -d $_work_dir/binx -sourcepath ${_work_dir}/src ${_work_dir}/src/ifs/cloud/fetch/Fetch.java
res=$?
if [ $res -ne 0 ]; then
	echo "$(date) ifs_fetch failed while compiling."
	exit 1
fi
echo "$(date) Creating executable ifs_fetch package..."
jar --create --main-class ifs.cloud.fetch.Fetch --file $_work_dir/ifs_fetch.jar -C $_work_dir/binx .
res=$?
rm -r $_work_dir/binx
rm -r $_work_dir/src
if [ $res -ne 0 ]; then
	echo "$(date) ifs_fetch failed while packaging executable."
	exit 1
fi
echo "$(date) Starting ifs_fetch tool..."
export FETCH_LOG=${_build_home}/ifs_fetch.log
java -jar $_work_dir/ifs_fetch.jar --build-home ${_build_home} ${_extra_args} ${_all_args} --repo-name binaryartifacts --host ifscloud.jfrog.io --workspace ${_work_dir}
exit $?