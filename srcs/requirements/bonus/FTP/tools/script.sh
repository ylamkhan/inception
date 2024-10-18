#!/bin/sh

adduser --gecos "" $FTP_USER 
echo "$FTP_USER:$FTP_PWD" | chpasswd
mkdir -p /home/$FTP_USER/ftp
chown -R "$FTP_USER:$FTP_USER" /home/$FTP_USER/ftp
echo "user_sub_token=$FTP_USER" >> /etc/vsftpd.conf;
echo "local_root=/home/$FTP_USER/ftp" >> /etc/vsftpd.conf;
echo "$FTP_USER" | tee -a /etc/vsftpd.userlist;

exec "$@"