#!/bin/sh
# Put FTP server details here
SERVER="1.2.3.4"
USERNAME="user_name"
PASSWORD="pwd"

# login to remote server
ftp -ipnv $SERVER <<EOF
user $USERNAME $PASSWORD
lcd /var/opt/gitlab/backups
cd /codelab-backup/varfile

mput *.tar
bye
EOF
