#!/bin/bash

# Fail the script when a subsuquent command or pipe redirection fails.
set -eo pipefail

# Variables.
RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
DEFAULT_COLOR='\033[0m'

# Function to get current datetime with Log level.
logger_prefix() {
if [[ "$1" = "e" ]]; then
  echo -e \\n${RED_COLOR}[$(date +"%Y-%m-%d %T") - $0] ERROR: ${DEFAULT_COLOR}
else
  echo -e \\n${GREEN_COLOR}[$(date +"%Y-%m-%d %T") - $0] INFO: ${DEFAULT_COLOR}
fi
}

bash ../../ifsinstaller/utils/verify_required_software.sh --jdk
if ! [ $? -eq 0 ]; then
    exit 1
fi

echo "$(logger_prefix) Execution started."

# Check whetehr the JDK is installed.
if ! command -v java >/dev/null 2>&1; then
  echo >&2 "$(logger_prefix e) Java is required.  Aborting as not found."
  exit 1
fi

# Process the command line arguements if any.
for ARGUMENT in "$@"
do
  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

  case "$KEY" in
    DELIVERY)                              DELIVERY=$VALUE ;;
    BUILD_HOME)                            BUILD_HOME=$VALUE ;;
    FORCE_TRANSLATIONS_DOWNLOAD)           FORCE_TRANSLATIONS_DOWNLOAD=$(echo $VALUE | tr a-z A-Z) ;;
    IFS_COMPONENTS_LIST)                   IFS_COMPONENTS_LIST=$VALUE ;;
    IFS_LANGUAGES_LIST)                    IFS_LANGUAGES_LIST=$VALUE ;;
    IFS_TRANSLATION_VERSION)               IFS_TRANSLATION_VERSION=$VALUE ;;
    *)   
  esac
done

# Check whether a valid Delivery path is defined.
if [[ -z "${DELIVERY}" ]]; then
  echo >&2 "$(logger_prefix e) Delivery path is not defined."
  exit 1
elif [[ ! -d "${DELIVERY}" ]]; then
  echo >&2 "$(logger_prefix e) Delivery path is not a directory."
  exit 1
else
  export DELIVERY=$DELIVERY
fi

# If Build Home is passed as an arguement, set it as an evnironment variable.
if [[ -n "${BUILD_HOME}" ]]; then
  export BUILD_HOME=$BUILD_HOME
fi

# Set FORCE_TRANSLATIONS_DOWNLOAD environment variable.
if [[ -z "${FORCE_TRANSLATIONS_DOWNLOAD}" ]] || [[ "$FORCE_TRANSLATIONS_DOWNLOAD" = "N" ]]; then
  export FORCE_TRANSLATIONS_DOWNLOAD=N
elif [[ "$FORCE_TRANSLATIONS_DOWNLOAD" = "Y" ]]; then
  export FORCE_TRANSLATIONS_DOWNLOAD=Y
else
  echo >&2 "$(logger_prefix e) Invalid value: $FORCE_TRANSLATIONS_DOWNLOAD provided for FORCE_TRANSLATIONS_DOWNLOAD option."
  exit 1
fi

# Set IFS_COMPONENTS_LIST environment variable.
if [[ -n "${IFS_COMPONENTS_LIST}" ]]; then
  JAR_ARGS+=" -DIFS_COMPONENTS_LIST=$IFS_COMPONENTS_LIST "
fi

# Set IFS_LANGUAGES_LIST environment variable.
if [[ -n "${IFS_LANGUAGES_LIST}" ]]; then
  JAR_ARGS+=" -DIFS_LANGUAGES_LIST=$IFS_LANGUAGES_LIST "
fi

# Set IFS_TRANSLATION_VERSION environment variable.
if [[ -n "${IFS_TRANSLATION_VERSION}" ]]; then
  JAR_ARGS+=" -DIFS_TRANSLATION_VERSION=$IFS_TRANSLATION_VERSION "
fi

# Check whether the config.properties file is present.
if [[ ! -f config.properties ]]; then
  echo >&2 "$(logger_prefix e) 'config.properties' file is required.  Aborting as not found in $(pwd)."
  exit 1;
fi

# Execute the translation_downloader.jsr file.
java $JAR_ARGS -jar translation-downloader.jar

echo "$(logger_prefix) Execution completed."
