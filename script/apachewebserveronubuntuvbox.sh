#!/bin/sh
# Run as root, ubuntu
# Create the vm, with 20gb of storage, 3gb of ram
# attach the iso images
# boot up the vm
# proceed with installation, use guided partitions and use entire disk
# reboot after install
# log in to your account
# run package database update command with:
apt update
# install needed depedency with command:
apt install apache2 bind9 dnsutils nano sudo resolvconf -y
# then, go to network settings on virtualbox, change adapter 1 attachment to host only adapter from NAT
# now we're gonna configure static IPs for adapter 1 (or enp0s3) with static IP are:
# 192.168.10.40
# with gateway:
# 192.168.10.1
# with the netplan configuration files that based on .yaml files
# with the common formats are:
# network:
#  version: 2
#  renderer: networkd
#  ethernets: (this part states the adapter kind, can be 'ethernets' or 'wifis')
#   enp0s3: (this is the target adapter, can be enp0s5 (adapter 2), enp0s8 (adapter 3) or enp0s9 (adapter 4))
#     dhcp4: false (states that this adapter will not use dhcp or dynamic ip/dns)
#     addresses:
#        - 192.168.10.40/24 (this is your static IPs)
#     routes:
#        - to: default
#          via: 192.168.10.1 (this is your gateway)
#      nameservers:
#        addresses: 
#        - 192.168.10.40 (this is your local dns)
# and we will apply all of this on a file named 'apache2-test.yaml'
# to make the change, execute this command:
cat <<'EOF' > /etc/netplan/apache2-test.yaml
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
# from this step were gonna configure local bind9 dns server that will point your custom domain to 192.168.10.40
# first backup the original configuration files
cp /etc/bind/named.conf-default.zones /etc/bind/named.conf-default.zones.bak
# second, we will be change the bind named.conf file with our desired domain (because this local) and our static ip we made before
# we'll gonna use rika.net as an example
sed -i 's|localhost|rika.net|g'  /etc/bind/named.conf-default.zones 
sed -i 's|db.local|db.rika|g'  /etc/bind/named.conf-default.zones 
sed -i 's|127|10.168.192|g'  /etc/bind/named.conf-default.zones 
sed -i 's|db.127|db.10|g'  /etc/bind/named.conf-default.zones 
# 6
