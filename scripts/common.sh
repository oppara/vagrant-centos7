#!/bin/bash
set -eu

# yum -y update kernel

# install for develop
yum -y install kernel-devel kernel-headers dkms
yum -y install mailx git sqlite-devel libmcrypt-devel openssl-devel gcc-c++ psmisc

# set up JST timezone
timedatectl set-timezone Asia/Tokyo

# disable SElinux
cp -p /etc/selinux/config /etc/selinux/config.orig
sed -i -e "s|^SELINUX=.*|SELINUX=disabled|" /etc/selinux/config

# set up vagrant public key
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub >> /home/vagrant/.ssh/authorized_keys


# set up ntpd
yum -y install ntp
systemctl enable ntpd
systemctl enable ntpdate
systemctl list-unit-files -t service | grep ntpd


# set up httpd
yum -y install httpd httpd-devel mod_ssl
systemctl enable httpd
systemctl list-unit-files -t service | grep httpd


