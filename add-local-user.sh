#!/bin/bash

# a script to create a new user

# script should be executed with root user privileges
if [ "$EUID" -ne 0 ]
	then echo "Please run as the root user."
	exit 1
fi

# prompt for information
read -p "Enter username: " USER_NAME
read -p "Enter full name: " COMMENT
read -p "Enter initial password: " PASS
echo "your username will be ${USER_NAME}"
# add the new user
useradd -c "${COMMENT}" -m ${USER_NAME}
if [ $? -ne 0 ]
	then echo "useradd command failed"
	exit 1
fi
# set the password
echo ${PASS} | passwd --stdin ${USERNAME}
if [ $? -ne 0 ]
	then echo "passwd command failed"
	exit 1
fi
# force password to expire on and be re-entered on next login
passwd -e ${USER_NAME}


echo "This account was created with username ${USERNAME}, password ${PASS}, and host $(hostname)."
