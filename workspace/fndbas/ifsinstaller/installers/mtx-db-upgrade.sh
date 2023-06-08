#!/bin/bash

help_args ()
{
echo
echo
echo Usage: mtx-db-upgrade.sh "-f <logFilePath>" "-b <bundlePath>" "-c <dbHost>" "-p <dbPort>" "-S <dbService>" "-u <userName>" "-P <passWord>" 
echo
echo "      logFilePath    Path to log file"
echo "      bundlePath     Path to bundle folder containing liquibase upgrade files"
echo "      dbHost         Database hostname"
echo "      dbPort         Database port"
echo "      dbService      Database service"
echo "      userName       Database schema username"
echo "      passWord       Username password"
echo
exit 1
}

if [[ $1 == "?" ]] || [[ $1 == "/?" ]] || [[ $1 == "--help" ]] || [[ $1 == "/help" ]]; then	
	help_args 
fi

LIB=../../mx-database/install/upgrade/lib
CLASSPATH=$LIB/*

java -cp "$CLASSPATH" com.mxi.mx.am.db.installer.Main -v "$@"
