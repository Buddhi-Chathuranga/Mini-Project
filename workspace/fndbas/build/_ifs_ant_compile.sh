#!/bin/bash
#clear
pushd `dirname $0`>/dev/null
CURDIR=`pwd`
RESULT=0
MSG=
CLEAN=
SCRIPT=`basename "$0"`
ANT_OPTS="-Xms1000M -Xmx3800M -Djava.util.concurrent.ForkJoinPool.common.parallelism=4"

# Default Home for Ant on the current server
cd $CURDIR/../..
TOOL_HOME=`pwd`/tools
cd $CURDIR

# Add ant to PATH
PATH=$TOOL_HOME/ant/bin:$PATH

run_default ()
{
	echo
	echo ant $CLEAN $DELIVERY_PROP
	ant $CLEAN $DELIVERY_PROP
	RESULT=$?
	if [ $RESULT -gt 0 ]; then
	  MSG="ant failed."
	fi
}

if [[ $1 == "CLEAN" ]]; then	
	CLEAN=clean-build 
fi

echo "$(date) Start $SCRIPT $CLEAN"

if [ -n "$DELIVERY" ] ; then
  DELIVERY_PROP=-Ddelivery="$DELIVERY"
  echo DELIVERY="$DELIVERY"
fi

# Default ant call
run_default
if [ $RESULT -gt 0 ]; then
  echo "$(date) Stop $SCRIPT $MSG"
  popd >/dev/null
  exit 1
fi

echo "$(date) Stop $SCRIPT $MSG"
popd >/dev/null
exit 0

