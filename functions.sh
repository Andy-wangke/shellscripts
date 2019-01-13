#!/bin/bash

# backups copy

###############################################
#Desc:
#common functions
###############################################


#if the need-installed program is installed,return 'installed ok installed'
#$1
getPackageInstallStatus_debian(){
	echo `dpkg-query -W -f='${Status}' "$1"`
}

#`rpm -qa | grep "$1"`
#`whereis "$1"`
#`yum -C list installed "$1"`
getPackageInstallStatus_rpm(){
	echo "TODO:currently not have any suitable command to check this process"
}

#install a package using RPM specified command(yum)
#$1:
install_rpm(){
	echo "-------------------------------------------------------------------------------------"


}

#install a package using debian specified command(apt-get)
#$1: package instaling
install_debian(){
	echo "-------------------------------------------------------------------------------------"

	getPackageInstallStatus=$(getPackageInstallStatus_debian $1)

	echo "INFO: Attempting to install" $1
	if[ "getPackageInstallStatus" ="install ok installed"];then
		echo "WARN: The package "$1"is already installed on your system"
	else
		apt-get -y install $1
	fi

}



check_is_root(){
	if ["`whoami`" != root ]; then 
		echo "[ERROR]: You must be root(or use 'sudo') in order to run this script." > &2
		exit 2
	fi
}


