#!/bin/bash

# $1 => New Hostname 
HOSTNAME=$1
SHORTNAME=${HOSTNAME%%.*}

# $2 => Saltmaster domain
SALT_MASTER=$2

# Set correct hostname
echo "${HOSTNAME}" > /etc/hostname
sed -i "s/changeme/$SHORTNAME/g" /etc/hosts

# Run the hostname init script
hostname "${HOSTNAME}"

# Drain entropy pool.
dd if=/dev/urandom of=/dev/null bs=1024 count=10 2>/dev/null

# Regenerate the keys.
rm -f /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server

# Set up salt, and start the salt service
mkdir -p /etc/salt/minion.d
apt-get install -y salt-minion

echo "master: $2" > /etc/salt/minion
echo "id: ${HOSTNAME}" >> /etc/salt/minion
echo "log_level: quiet" >> /etc/salt/minion

service salt-minion start

# Grow the disk
# This is specific to the 32GB cards.
# Only run if $3 is set to "grow" 
if [[ $3 
if [[ $3 == "grow" ]] ; then
  echo "GROW"
  #parted -s /dev/mmcblk0 resizepart 2 32GB 
  #resize2fs /dev/mmcblk0p2 30200M
fi
