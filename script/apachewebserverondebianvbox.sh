#!/bin/sh
# Run as root, debian 12+, ubuntu 22.04+
# 1
apt update
# 2
apt install apache2 bind9 dnsutils nano sudo -y
# 3
cat <<'EOF' > /etc/netplan/00-apache2-test.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: false
      addresses:
        - 192.168.10.40/24
      routes:
        - to: default
          via: 192.168.10.1
      nameservers:
        addresses: 
        - 192.168.10.40
EOF
#4
cp /etc/bind/named.conf-default.zones /etc/bind/named.conf-default.zones.bak
#5
sed -i 's|localhost|rika.net|g'  /etc/bind/named.conf-default.zones 
sed -i 's|db.local|db.rika|g'  /etc/bind/named.conf-default.zones 
sed -i 's|127|10.168.192|g'  /etc/bind/named.conf-default.zones 
sed -i 's|db.127|db.10|g'  /etc/bind/named.conf-default.zones 
# 6
