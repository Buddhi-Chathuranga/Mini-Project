#!/bin/bash
#clear
pushd `dirname $0`>/dev/null
CURDIR=`pwd`
RESULT=0
MSG=
CLEAN=
SCRIPT=`basename "$0"`
ANT_OPTS="-Xms1000M -Xmx3800M -Djava.util.concurrent.ForkJoinPool.common.parallelism=4"
ARGS="$@"

# Build home
cd $CURDIR/..
BUILD_HOME=`pwd`
cd $CURDIR

# Default Home for Ant on the current server
cd $CURDIR/../..
TOOL_HOME=`pwd`/tools
cd $CURDIR

# Add ant to PATH
PATH=$TOOL_HOME/ant/bin:$PATH

validate ()
{
	echo
	echo $BUILD_HOME/ifsinstaller/utils/validate-solution-set-file.sh deliveryPath=$DELIVERY buildHomePath=$BUILD_HOME
	bash $BUILD_HOME/ifsinstaller/utils/validate-solution-set-file.sh deliveryPath=$DELIVERY buildHomePath=$BUILD_HOME
	RESULT=$?
	if [ $RESULT -gt 0 ]; then
	  MSG="Validation of solutionset file failed."
	fi
}

run_default ()
{
	echo
	echo ant -f build_generate_db.xml $CLEAN generate $DELIVERY_PROP
	ant -f build_generate_db.xml $CLEAN generate $DELIVERY_PROP
	RESULT=$?
	if [ $RESULT -gt 0 ]; then
	  MSG="ant failed."
	fi
}

create_installtem ()
{
	echo
	echo $BUILD_HOME/ifsinstaller/utils/create-install-tem.sh deliveryPath=$DELIVERY buildHomePath=$BUILD_HOME $ARGS
	bash $BUILD_HOME/ifsinstaller/utils/create-install-tem.sh deliveryPath=$DELIVERY buildHomePath=$BUILD_HOME $ARGS
	RESULT=$?
	if [ $RESULT -gt 0 ]; then
	  MSG="Creation of merged files and/or install.tem failed."
	fi
}

copy-CreateInstallTem-files-to-build ()
{
	echo
	echo ant -f build_generate_db.xml copy-CreateInstallTem-files-to-build $DELIVERY_PROP
	ant -f build_generate_db.xml copy-CreateInstallTem-files-to-build $DELIVERY_PROP
	RESULT=$?
	if [ $RESULT -gt 0 ]; then
	  MSG="copy-CreateInstallTem-files-to-build failed."
	fi
}

# Main
if [[ $1 == "CLEAN" ]]; then	
	CLEAN=clean 
fi

echo "$(date) Start $SCRIPT $CLEAN"

if [ -n "$DELIVERY" ] ; then
  DELIVERY_PROP=-Ddelivery="$DELIVERY"
  echo DELIVERY="$DELIVERY"
fi

# Validation of solutionset file
if [ -z "$DELIVERY" ] ; then
  DELIVERY="$BUILD_HOME"
fi
validate
if [ $RESULT -gt 0 ]; then
  echo "$(date) Stop $SCRIPT $MSG"
  popd >/dev/null
  exit 1
fi
#If DB_OPTION set to "validate", only validation of solutionset files should be executed.
if [[ $DB_OPTION == "VALIDATE" ]]; then	
  echo "$(date) Stop $SCRIPT $MSG"
  popd >/dev/null
  exit $RESULT
fi

# Default ant call
run_default
if [ $RESULT -gt 0 ]; then
  echo "$(date) Stop $SCRIPT $MSG"
  popd >/dev/null
  exit 1
fi

# Call to create_intalltem
if [ -z "$DELIVERY" ] ; then
  DELIVERY="$BUILD_HOME"
fi
create_installtem 
if [ $RESULT -gt 0 ]; then
  echo "$(date) Stop $SCRIPT $MSG"
  popd >/dev/null
  exit 1
fi

export DELIVERY_PROP="$DELIVERY_PROP -DbuildhomePath=$BUILD_HOME/database -DdeliveryPath=$DELIVERY/database"
copy-CreateInstallTem-files-to-build 
if [ $RESULT -gt 0 ]; then
  echo "$(date) Stop $SCRIPT $MSG"
  popd >/dev/null
  exit 1
fi

echo "$(date) Stop $SCRIPT $MSG"
popd >/dev/null
exit 0

