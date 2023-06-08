#!/bin/bash
# ifs_build.sh
#
# subroutines
# 

wrong_args ()
{
echo
echo Current args: "$ARGS"
echo Help script for running 'build'.
echo
echo "Usage: bash $SCRIPT [--userName=\"userName\" --password=\"password\" --connectString=\"connectString\"] [--clean] [--nodb] [--validate]"
echo
echo "            start ./_ifs_ant_compile.sh $CLEAN     > $BUILD_HOME/_ifs_ant_compile.log"
echo "            start ./_ifs_ant_generatedb.sh $CLEAN  > $BUILD_HOME/_ifs_ant_generatedb.log"
echo
echo "            userName, password, connectString, optional arguments to connect to database and create install_tem"
echo "            --clean    adds CLEAN as argument"
echo "            --nodb     skip start ./_ifs_ant_generatedb.sh"
echo "            --validate start ./_ifs_ant_generatedb.sh VALIDATE and exit"
echo
echo "            set DELIVERY with environment variable"
echo "Example:"
echo
echo "       export DELIVERY=/opt/ifs/delivery"
echo "       bash ./$SCRIPT" '--userName="ifsapp" --password="IFSAPP" --connectString="jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=1.2.3.4)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=sb)))"'
echo
exit 2
}

install_tools () {
 # Install Tools
 # java is pre-installed
 # ant is unpacked during fetch
 export WORK_HOME=../tools
 export PATH=$WORK_HOME/ant/bin:$PATH
 chmod +x $WORK_HOME/ant/bin/ant
}

create_xml () {

cat << EOF > $XML_FILE
<?xml version="1.0" encoding="UTF-8"?>
<project name="build" basedir="." default="copy-from-delivery">
<target name="copy-from-delivery">
  <parallel>
  <copy todir="$BUILD_HOME" preservelastmodified="false" overwrite="true" failonerror="false" force="true">
    <fileset dir="$DELIVERY">
      <include name="source/**"/>
      <exclude name="source/*/client/**"/>
    </fileset>
   </copy>
  <copy todir="$BUILD_HOME" preservelastmodified="false" overwrite="true" failonerror="false" force="true">
    <fileset dir="$DELIVERY">
      <include name="model/**"/>
    </fileset>
  </copy>
  <copy todir="$BUILD_HOME" preservelastmodified="false" overwrite="true" failonerror="false" force="true">
    <fileset dir="$DELIVERY">
      <exclude name="model/**"/>
      <exclude name="source/**"/>
      <exclude name="client/runtime/**"/>
      <exclude name="*.log"/>
      <exclude name="*.ini"/>
    </fileset>
  </copy>
  <copy todir="$BUILD_HOME" preservelastmodified="false" overwrite="true" failonerror="false" force="true">
    <fileset dir="$DELIVERY">
      <include name="layers.ini"/>
      <include name="solutionset.ini"/>
      <include name="solutionset.yaml"/>
    </fileset>
  </copy>
  </parallel>
</target>
<target name="copy-ifsinstaller-to-delivery">
  <copy todir="$DELIVERY" preservelastmodified="true" overwrite="false" failonerror="false" force="true">
    <fileset dir="$BUILD_HOME">
      <include name="ifsinstaller/**"/>
      <exclude name="ifsinstaller/image-versions/**"/>
      <exclude name="ifsinstaller/utils/validate-solution-set-file.*"/>
      <exclude name="ifsinstaller/utils/create-install-tem.*"/>
    </fileset>
  </copy>
</target>
<target name="unpack_zip">
  <taskdef resource="net/sf/antcontrib/antlib.xml"/>
  <echo message="starting" level="info"/>
  <echo message="zipunpack.folder: \${zipunpack.folder}" level="info"/>
  <fileset id="ref.zips" dir="\${zipunpack.folder}">
    <include name="source/*/zip/*.zip"/>
  </fileset>
  <pathconvert pathsep="," property="zips" refid="ref.zips" setonempty="false"/>
  <echo>zips: \${zips} </echo>
  <foreach list="\${zips}" param="zipfile.name" target="do-unzip" inheritall="true"/>
</target>
<target name="do-unzip" if="zips">
  <echo message="\${zipfile.name}" level="info"/>
  <unzip src="\${zipfile.name}" dest="\${zipunpack.folder}/temp_unzip"/>
  <copy todir="\${zipunpack.folder}" overwrite="true" preservelastmodified="true">
    <fileset dir="\${zipunpack.folder}/temp_unzip/build_home"/>
  </copy>
  <subant failonerror="false">
    <fileset dir="\${zipunpack.folder}/temp_unzip" includes="build.xml"/>
  </subant>
  <delete dir="\${zipunpack.folder}/temp_unzip"/>
</target>
</project>
EOF
}



###### main
CURDIR="$(pwd)"
cd ..
export BUILD_HOME="$(pwd)"
cd $CURDIR
export SCRIPT=${0##*/}

export SERVER=true
export DB=true
export DB_OPTION=
export OPTS=
export ARGS=
export XML_FILE=delivery.xml
export CLEAN=
ARGS="$@"

for i in "$@"
do
case $i in
    --nodb)
    DB=false
    shift
    ;;
    --clean)
    CLEAN=CLEAN
    shift
    ;;
    --validate)
    DB_OPTION=VALIDATE
    shift
    ;;
    --userName=*)
    OPTS="$OPTS $i"
    shift
    ;;
    --password=*)
    OPTS="$OPTS $i"
    shift
    ;;
    --connectString=*)
    OPTS="$OPTS $i"
    shift
    ;;
    *)
    wrong_args $@
    ;;
esac
done

bash ../ifsinstaller/utils/verify_required_software.sh --jdk
if ! [ $? -eq 0 ]; then
    exit 1
fi


echo `date` Start $SCRIPT $@

#echo ARGS=$ARGS
#echo SERVER=$SERVER
#echo DB=$DB
#echo DB_OPTION=$DB_OPTION
#echo OPTS=$OPTS
#echo CLEAN=$CLEAN


# ifs_build.sh in delivery?
if [ -n "$DELIVERY" ]; then
  export DELIVERY
  export delivery=$DELIVERY
  echo DELIVERY=$DELIVERY
  if [ -f $DELIVERY/build/$SCRIPT ]; then 	
    if ! (cmp -s $DELIVERY/build/$SCRIPT  $CURDIR/$SCRIPT);then 
      echo `date` $SCRIPT exists in delivery. Copy new version and restart...
      echo cp $DELIVERY/build/$SCRIPT $BUILD_HOME/build/$SCRIPT \& bash $CURDIR/$SCRIPT $ARGS 
      cp $DELIVERY/build/$SCRIPT $BUILD_HOME/build/$SCRIPT && bash $CURDIR/$SCRIPT $ARGS && exit 
    fi
  fi
fi

install_tools

if [ -n "$OPTS" ]; then
# if ! [ `echo "$userName" "$password" "$connectString" |wc -w` -eq 3 ]; then
 if ! [ `echo "$OPTS" |wc -w` -eq 3 ]; then
   echo Error: userName and password and connectString are required if used
   exit 1
 fi
fi

# Compile
create_xml

if [ -n "$DELIVERY" ]; then export ZIP_UNPACK_FOLDER=$DELIVERY; else export ZIP_UNPACK_FOLDER=$BUILD_HOME; fi

echo `date` ant -f $XML_FILE unpack_zip -Dzipunpack.folder=$ZIP_UNPACK_FOLDER \> $CURDIR/unpack_zip.log 2\>\&1
rm -f $CURDIR/unpack_zip.log
ant -v -f $XML_FILE unpack_zip -Dzipunpack.folder=$ZIP_UNPACK_FOLDER > $CURDIR/unpack_zip.log 2>&1
RESULT=$?
grep "BUILD SUCCESSFUL" $CURDIR/unpack_zip.log > /dev/null 2>&1
if ! ([ $RESULT -eq 0 ]); then echo ant failed, check CURDIR/unpack_zip.log && exit $RESULT; fi

if [ -n "$DELIVERY" ]; then 
  echo `date` Copy $DELIVERY to $BUILD_HOME...
  rm -f $CURDIR/delivery.log
  echo `date` ant -f $XML_FILE \> $CURDIR/delivery.log 2\>\&1
  ant -v -f $XML_FILE > delivery.log 2>&1
  RESULT=$?
  grep "BUILD SUCCESSFUL" $CURDIR/delivery.log > /dev/null 2>&1
  if ! ([ $RESULT -eq 0 ]); then echo ant failed, check CURDIR/delivery.log && exit $RESULT; fi
  echo `date` ant -v -f $XML_FILE copy-ifsinstaller-to-delivery \> $CURDIR/copy-ifsinstaller-to-delivery.log 2\>\&1
  ant -v -f $XML_FILE copy-ifsinstaller-to-delivery > $CURDIR/copy-ifsinstaller-to-delivery.log 2>&1
  RESULT=$?
  grep "BUILD SUCCESSFUL" $CURDIR/copy-ifsinstaller-to-delivery.log > /dev/null 2>&1
  if ! ([ $RESULT -eq 0 ]); then ant failed, check CURDIR/copy-ifsinstaller-to-delivery.log && exit $RESULT; fi
fi

# SERVER
_ifs_ant_compile_RESULT=0
_ifs_ant_generatedb_RESULT=0
if [ -n "$SERVER" ]; then 
  echo `date` _ifs_ant_compile.sh $CLEAN "$OPTS" \> $BUILD_HOME/_ifs_ant_compile.log 2\>\&1
  bash $CURDIR/_ifs_ant_compile.sh $CLEAN "$OPTS" > $BUILD_HOME/_ifs_ant_compile.log 2>&1
  _ifs_ant_compile_RESULT=$?
fi

# VALIDATE
if [ -n "$DB_OPTION" ]; then 
  echo `date` _ifs_ant_generatedb.sh DB_OPTION="$DB_OPTION" \> $BUILD_HOME/_ifs_ant_generatedb.log 2\>\&1
  bash $CURDIR/_ifs_ant_generatedb.sh  DB_OPTION="$DB_OPTION"  > $BUILD_HOME/_ifs_ant_generatedb.log 2>&1
  _ifs_ant_generatedb_validate_RESULT=$?
  if [ $_ifs_ant_generatedb_validate_RESULT -eq 0 ]; then
    echo `date` _ifs_ant_generatedb $DBOPTION Successful.
  else
    echo `date` _ifs_ant_generatedb $DBOPTION Failed. Check logfile $BUILD_HOME\/_ifs_ant_generatedb.log
  fi
  exit $_ifs_ant_generatedb_validate_RESULT
fi

# DB
if [[ "$DB" == "true" ]]; then 
  echo `date` _ifs_ant_generatedb.sh $CLEAN  "$OPTS" \> $BUILD_HOME/_ifs_ant_generatedb.log 2\>\&1
  bash $CURDIR/_ifs_ant_generatedb.sh $CLEAN  "$OPTS" > $BUILD_HOME/_ifs_ant_generatedb.log 2>&1
  _ifs_ant_generatedb_RESULT=$?
fi

echo `date` Build done

if [ -n "$SERVER" ]; then 
  if [ $_ifs_ant_compile_RESULT -eq 0 ]; then
    echo `date` _ifs_ant_compile Successful. 
  else
    echo `date` _ifs_ant_compile Failed. Check logfile $BUILD_HOME\/_ifs_ant_compile.log 
  fi
fi

if [[ "$DB" == "true" ]]; then 
  if [ $_ifs_ant_generatedb_RESULT -eq 0 ]; then
    echo `date` _ifs_ant_generatedb Successful. 
  else
    echo `date` _ifs_ant_generatedb Failed. Check logfile $BUILD_HOME\/_ifs_ant_generatedb.log 
  fi
fi

if ! ( [ $_ifs_ant_compile_RESULT -eq 0 ] && [ $_ifs_ant_generatedb_RESULT -eq 0 ] ) ; then exit 1;fi
