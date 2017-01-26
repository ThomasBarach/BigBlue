#!/bin/bash

# Bash script to feed shinken host files
# Usage : ./host.sh $HOSTNAME$ $ADDRESS$


green = '\033[1;92m'
red = '\033[1;91m'
blue = '\033[1;94m'
nc = '\033[0m'

host = $1
address = $2

if [ -e /etc/shinken/hosts/$host.cfg ]; then
  echo -e "${red}File $host already exists, let's move on${nc}"
 
else 
  touch /etc/shinken/hosts/$host.cfg
  echo "define host {
use         BigBlue
host_name   $host
address     $address
hostgroups  BigBlues
}" >> /etc/shinken/hosts/$host.cfg
  
  echo -e "${blue}File $host.cfg created${nc}"

fi 
