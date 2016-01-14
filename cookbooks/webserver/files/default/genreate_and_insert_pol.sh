#!/usr/bin/env bash

# check if policy is already installed
semodule -l|grep reapolicy
is_installed=$?
if [[ is_installed -eq 0 ]]
then
 echo  "policy already installed"
 exit 0
fi

set -e
#remove old files
rm -f reapolicy.mod reapolicy.pp

#generate selinux module from te file
checkmodule -M -m -o reapolicy.mod reapolicy.te

#compile selinux module into selinux policy file
semodule_package -o reapolicy.pp -m reapolicy.mod

# Load the generated policy file
semodule -i reapolicy.pp

