#!/bin/bash
set -eu

yum -y install postgresql-server postgresql-devel
su postgres -c '/usr/bin/initdb --no-locale -D  /var/lib/pgsql/data'
systemctl start postgresql
/usr/bin/createuser -d -A -S -U postgres vagrant
systemctl stop postgresql
systemctl disable postgresql
systemctl list-unit-files -t service | grep postgresql
