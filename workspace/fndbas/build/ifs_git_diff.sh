#!/bin/bash
# git_diff.sh
#
# subroutines
wrong_args ()
{
echo
echo Current args: "$ARGS"
echo
echo "Usage: bash $SCRIPT --gitcheckout=\"Path to git checkout\" --fromtag=\"from Tag\" --totag=\"to Tag\" [--filelistname=\"path + filename\"] [--deleted]"
echo
echo "            --filelistname optional, if not defined, default file name is <--gitcheckout>\..\diff_file_list.txt."
echo "                                     If --onlydeleted is defined, default file name is <--gitcheckout>\..\deleted_file_list.txt."
echo "            --deleted  optional, deleted files between the tags will be spooled to file."
echo
echo "Example:"
echo
echo "       bash ./$SCRIPT" '--gitcheckout "/opt/ifs/customer1/workspace" --fromtag "tag delvery1" --totag "tag delivery2"'
echo "       bash ./$SCRIPT" '--gitcheckout "/opt/ifs/customer1/workspace" --fromtag "tag delvery1" --totag "tag delivery2" --filelistname "/opt/ifs/customer1/workspace/deleted_files.txt" --deleted'
echo
exit 2
}

###### main
CURDIR="$(pwd)"
export SCRIPT=${0##*/}
ARGS="$@"

unset _GITCHECKOUT
unset _FROMTAG
unset _TOTAG
unset _FILELISTNAME
unset _DELETED
while [ "$1" != "" ]; do
    case $1 in
	    --gitcheckout )
		 	shift
			_GITCHECKOUT=$1
		;;
		--fromtag )
		 	shift
			_FROMTAG=$1
		;;
		--totag )
		 	shift
			_TOTAG=$1
		;;
		--filelistname )
		 	shift
			_FILELISTNAME=$1
		;;
		--deleted )
			_DELETED=true
		;;
		*)
			wrong_args $@
		;;		
    esac
    shift
done

echo `date` Start $SCRIPT $@

# ifs_git_diff in gitcheckout?
if [ -f $_GITCHECKOUT/fndbas/build/$SCRIPT ]; then 	
  if ! (cmp -s $_GITCHECKOUT/fndbas/build/$SCRIPT $CURDIR/$SCRIPT);then 
    echo `date` $SCRIPT exists in gitcheckout. Copy new version and restart...
    echo cp $_GITCHECKOUT/fndbas/build/$SCRIPT $CURDIR/$SCRIPT \& bash $CURDIR/$SCRIPT $ARGS 
    cp $_GITCHECKOUT/fndbas/build/$SCRIPT $CURDIR/$SCRIPT && bash $CURDIR/$SCRIPT $ARGS && exit 
  fi
fi

if [[ -z $_GITCHECKOUT ]] || [[ -z $_FROMTAG ]] || [[ -z $_TOTAG ]]; then
   echo "Mandatory parameters missing"
   wrong_args $@
fi

git --version > /dev/null 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
	echo "ERROR: git command not found!"
	exit 1
fi

echo `date` Changes folder to $_GITCHECKOUT
cd $_GITCHECKOUT
diff_filter=ACMRT 
output_file=$_GITCHECKOUT/../diff_file_list.txt
if [[ "$_DELETED" == "true" ]]; then 
  diff_filter=D 
  output_file=$_GITCHECKOUT/../deleted_file_list.txt
fi
if [[ -n $_FILELISTNAME ]]; then 
  output_file=$_FILELISTNAME
fi
echo `date` /usr/bin/git/git diff-tree -r --no-commit-id --name-only --diff-filter=$diff_filter $_FROMTAG $_TOTAG $output_file
git diff-tree -r --no-commit-id --name-only --diff-filter=$diff_filter $_FROMTAG $_TOTAG > $output_file  2>&1
RESULT=$?
echo `date` Changes folder back to $CURDIR
cd $CURDIR
exit $RESULT
