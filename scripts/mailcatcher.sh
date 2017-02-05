#!/bin/bash
set -eu

# set up ruby & mailcatcher
yum -y install ruby-devel
gem install bundler mailcatcher --no-ri --no-rdoc --clear-sources
cat > /usr/lib/systemd/system/mailcatcher.service <<EOF
[Unit]
Description = mailcatcher

[Service]
ExecStart = /usr/local/bin/mailcatcher --foreground --http-ip=0.0.0.0
Restart = always

[Install]
WantedBy = multi-user.target
EOF

systemctl enable mailcatcher
systemctl list-unit-files -t service | grep mailcatcher
