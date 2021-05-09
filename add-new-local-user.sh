#!/bin/bash

# a script to create a new user

# script should be executed with root user privileges
if [ "$EUID" -ne 0 ]
	then echo "Please run as the root user."
	exit 1
fi
# verify number of arguments
if [ ${#} -lt 1 ]
	then echo "Please pass the account name as argument 1."
	exit 1
fi
if [ ${#} -lt 2 ]
	then echo "After the account name, please enter the text for a comment about the account."
	exit 1
fi

# assign variables from arguments
USER_NAME=${1}
COMMENT=${2}
while [ ${#} -gt 2 ]
do
	shift
	COMMENT="${COMMENT} ${2}"
done
# generate a password
date +%s%N | sha256sum >> passwords.txt
PASS=$(fold --width=8 passwords.txt | head -1)
rm passwords.txt
echo "Generated password is: ${PASS}"
# create the account
echo "Creating account with username ${USER_NAME} and comment ${COMMENT}"
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
