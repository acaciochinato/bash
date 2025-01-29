#!/bin/bash
#########################################################################
#                                                                       #
# Date: 15/02/2023                                                      #
#                                                                       #
# Description: Automate the process of user creation for SFTP access.   #
#                                                                       #
#########################################################################
NAME=
SFTP_PATH="/srv/sftp"
SFTP_GROUP="sftpusers"

Main () {
    [[ $UID -ne 0 ]] && echo "sudo access required!" && exit 1
    read -p "Type the username without spaces: " -r NAME
    read -p "Password for $NAME: " -r PASSWORD
    RVAL=$?
    SFTP_HOME="$SFTP_PATH/$NAME/home"
}
Create () {
   echo "Creating user $NAME" && useradd -s /usr/sbin/nologin -mk /etc/skel.empty -d "$SFTP_HOME" -g "$SFTP_GROUP" "$NAME"
   echo "$NAME":"$PASSWORD" | chpasswd
}

while [[ $RVAL -ne 0 || -z "$NAME" || -z "$PASSWORD" ]]; do
  Main
  if [[ $RVAL -ne 0 || -z "$NAME" || -z "$PASSWORD" ]]; then
    clear
    cat <<EOF
Please, provide the name and password for the user that will use the SFTP service:
  
Example:
Username: john
Password: mypassword

Or to abort, type "CTRL + C"
EOF

    Main 
  else
    break
  fi
done

Create