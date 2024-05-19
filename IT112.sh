#/bin/sh

# Author: Allen Gabrielle Cruiz
# Github: https://www.github.com/AlienWolfX
# Date: 2024-19-05
# Version: 1.0
# Description: This script is used to install the required packages for IT112 Project

# Preparing the system for installation
sudo apt-get update && sudo apt-get upgrade -y


# Lab 1: Installing Apache2
sudo apt install apache2 -y
sudo systemctl status apache2
sleep 4

# Lab 2: 
sudo apt install openssh-server -y
sudo systemctl restart sshd.service

# Lab 3:
sudo apt install nfs-kernel-server

    # Creating the directories for the NFS
    sudo mkdir -p /srv/nfs4/backups
    sudo mkdir -p /srv/nfs4/www

    # Binding the directories to the NFS
    sudo mount --bind /opt/backups /srv/nfs4/backups
    sudo mount --bind /var/www /srv/nfs4/www

    # Appending the directories to the fstab
    echo "/opt/backups /srv/nfs4/backups  none   bind   0   0" | sudo tee -a /etc/fstab
    echo "/var/www     /srv/nfs4/www      none   bind   0   0" | sudo tee -a /etc/fstab

    # Exporting the directories
    export host(options)

    # Exportfs
    third=$(hostname -I | cut -d'.' -f3)

    lines="/srv/nfs4         192.168.$third.0/24(rw,sync,no_subtree_check,crossmnt,fsid=0)
    /srv/nfs4/backups 192.168.$third.0/24(ro,sync,no_subtree_check) 192.168.$third.3(rw,sync,no_subtree_check)
    /srv/nfs4/www     192.168.$third.20(rw,sync,no_subtree_check)"

    echo "$lines" | sudo tee -a /etc/exports

    sudo exportfs -ar
    sudo exportfs -v

    # Firewall
    sudo ufw allow from 192.168.$third.0/24 to any port nfs
    sudo ufw status