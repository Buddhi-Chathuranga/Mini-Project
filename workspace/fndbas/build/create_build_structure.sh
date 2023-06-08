
#!/bin/bash

_usage() {
   echo "Usage: create_build_structure.sh {path_to_componets} {path_to_delivery | path_to_build}"
   echo "Create the delivery or build-home folder structure."
   echo "All arguments are mandatory."
   echo ""
   echo "Only one of path_to_delivery or path_to_build must be provided."
   echo  "path_to_componets"
   echo  "--components         Components folder."
   echo  "                     This must be a valid folder with all required components."
   echo  "                     It is not created during runtime."
   echo  "path_to_delivery"
   echo  "--delivery path      Folder where the delivery structure is generated."
   echo  "                     It is created during runtime if it is not found."
   echo  "path_to_build"
   echo  "--build path         Folder where the build-home structure is generated."
   echo  "                     It is created during runtime if it is not found."
}

_usage_error() {
   echo "ERROR: $1"
   echo ""
   _usage
   exit 1
}

_error() {
   echo "ERROR: $1"
   exit 1
}

_convert_to_title_case() {
    sed 's/.*/\L&/; s/[a-z]*/\u&/g' <<<"$1"    
}

_parse_deploy_ini() {
   filename=$1
   section_pattern="\[(.+)\]"
   name_pattern="Name\=(.+)$"
   component_section=0
   connections_section=0
   while IFS= read -r line || [ -n "$line" ]; do
      # reading each line
      if [[ $line =~ $section_pattern ]]; then
         section=${BASH_REMATCH[1]}
         if [[ $section = "Component" ]]; then
            component_section=1
         elif [[ $section = "Connections" ]]; then
               connections_section=1
               connections=
         else
            component_section=0
            connections_section=0
         fi
      else
         if [ $component_section -eq 1 ]; then
            if [[ $line =~ $name_pattern ]]; then
               name=${BASH_REMATCH[1]}
            fi
         fi
         if [ $connections_section -eq 1 ]; then
            line=$(echo $line|tr -d '\n')
            line=$(echo $line|tr -d '\r')
            if [ ${#line} -gt 0 ]; then
               arr=(${line//=/ })
               comp_name="$(_convert_to_title_case "${arr[0]}")"
               connections=${connections}${comp_name}"."${arr[1]}";"
            fi
         fi
      fi
   done < $filename
}


_process_deploy_ini() {
   _parse_deploy_ini "$2"
   _component="$(_convert_to_title_case "$1")"
   target_file="${target}database/${_component}.ini"
   cp $2 $target_file
   # fresh only
   if [ $delivery_mode -eq 0 ]; then
      module_connections="${_component}=${connections}"
      echo $module_connections >> $mc_tmp
      installed_versions="${_component^^}=FreshInstall"
      echo $installed_versions >> $iv_tmp
   fi
}

_create_target_struct() {
   echo "Generating ${type} structure..."
   if ! test -d ${target}database ; then
      if ! mkdir -p ${target}database ; then
         echo "ERROR: Failed creating database folder."
      fi
   fi
   echo "[ModuleConnections]" > $mc_tmp
   echo "[InstalledVersions]" > $iv_tmp
   for _f in $(find ${components}* -maxdepth 0 -type d); do 
      _component=$(basename ${_f})
      echo "Updating component ${_component}..."
      rsync -rq --progress ${_f}/ $target --exclude deploy.ini --exclude .svn --exclude .git  --exclude .vscode --exclude nobuild --exclude cvs --exclude misc --exclude conditionalbuild
      # deploy.ini -> {Component}.ini
      deploy_ini="${_f}/deploy.ini"
      if test -f "${deploy_ini}" ; then
         _process_deploy_ini "${_component}" "$deploy_ini"
      fi
   done

   if [ $delivery_mode -eq 0 ]; then
      echo "" >> $mc_tmp
      cat $mc_tmp $iv_tmp > $install_ini
   else
      >$install_ini
   fi
   rm $mc_tmp
   rm $iv_tmp
}

echo ""
echo "BUILD STRUCTURE UTILITY 1.0.0"

delivery_mode=2
while [ "$1" != "" ]; do
    case $1 in
         --components )
            shift
            components=$1
         ;;
         --build )
            shift
            target=$1
            delivery_mode=0;
            type=build-home
         ;;
         --delivery )
            shift
            target=$1
            delivery_mode=1;
            type=delivery
         ;;
         --help )
            shift
            _usage
            exit 0
         ;;
    esac
    shift
done

if [ -z ${components+x} ]; then
   _usage_error "Mandatory argument 'path_to_componets' is missing."
fi
if ! test -d "$components" ; then
   _error "Components folder was not found."
fi
if [ -z ${target+x} ]; then
   _usage_error "Mandatory argument 'path_to_delivery' or 'path_to_build' is missing."
fi
if ! test -d "$target" ; then
   if ! mkdir -p "$target" ; then
      _error "Failed creating target ${type} folder."
   fi
fi
# add extra '/' to the path
if [[ ! "$components" == */ ]]; then
   components="${components}/"
fi
if [[ ! "$target" == */ ]]; then
   target="${target}/"
fi
# check for updated script in components folder
if [ $delivery_mode -eq 1 ]; then
   _file_in_deliv=${components}fndbas/build/create_build_structure.sh
   if test -f ${_file_in_deliv} ; then
      if ! cmp -s "${_file_in_deliv}" "$0"; then
         echo "Modified create_build_structure.sh in ${components}."
         echo "Switching to script in ${components}..."
         ${_file_in_deliv} -c $components -d $target
         _retn_code=$?
         exit ${_retn_code}
      fi
   fi
fi

mc_tmp=${target}database/module_connections.tmp
iv_tmp=${target}database/installed_versions.tmp
install_ini=${target}database/Install.ini

_create_target_struct
echo "done."
