#!/bin/sh
#===============================================================================
#
#          FILE:  startWEB.sh
# 
#         USAGE:  ./startWEB.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:   (), 
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  01/01/2009 04:05:39 PM HKT
#      REVISION:  ---
#===============================================================================
#sudo /etc/rc.d/nginx start
sudo /etc/rc.d/httpd start
#sleep 5
#sudo /etc/rc.d/init-fastcgi start
sleep 5
sudo /etc/rc.d/mysqld start

