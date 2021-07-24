function install_pkg (){
  # check if $AUR_HELPER is installed, if not then bail
  if [[ -z $(which $AUR_HELPER 2> /dev/null) ]];
  then
    2> echo "$AUR_HELPER isn't installed, please install then retry"
    exit 1
  fi
  
  $AUR_HELPER -Sy $@
}
