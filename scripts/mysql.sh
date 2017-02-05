#!/bin/bash
set -eu

yum -y remove mariadb-libs
yum -y localinstall http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum -y install postfix
yum -y install mysql-community-devel mysql-community-server

systemctl start mysqld

tmp_mysql_pass=$(grep 'password is generated' /var/log/mysqld.log | awk -F'root@localhost: ' '{print $2}')
tmp_my_conf=/root/.tmp.my.cnf
umask 0077
cat > $tmp_my_conf <<EOF
[client]
user=root
password=$tmp_mysql_pass
connect-expired-password
EOF

new_mysql_pass='MyNewPass4@'
mysql --defaults-file=$tmp_my_conf -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$new_mysql_pass';"
root_my_conf=/root/.my.cnf
umask 0077
cat > $root_my_conf <<EOF
[client]
user=root
password=$new_mysql_pass
EOF

cat >> /etc/my.cnf <<EOF

character-set-server=utf8mb4
default_password_lifetime=0
validate_password_policy=LOW
validate_password_length=4

[client]
default-character-set=utf8mb4
EOF

systemctl restart mysqld
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"
sed -i -e "s|^password=.*|password=root|" $root_my_conf

mysql -e "GRANT ALL ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant';"
mysql -e "GRANT ALL ON *.* TO 'vagrant'@'localhost' IDENTIFIED BY 'vagrant';"
mysql -e "GRANT ALL ON *.* TO 'vagrant'@'127.0.0.1' IDENTIFIED BY 'vagrant';"

systemctl stop mysqld
systemctl disable mysqld
