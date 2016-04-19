#!/bin/sh

#Update uim-install.sh with the primary hub IP
sed -i "s/uim-primary-hub-ip/${uim_primary_hub_ip}/g" /tmp/uim/uim-install.sh
sed -i "s/uim-primary-hub-dom/${uim_primary_hub_dom}/g" /tmp/uim/uim-install.sh

#Move uploaded files into place
mkdir -p /opt/nimsoft/robot
mv /tmp/uim/uim-install.sh /var/lib/cloud/scripts/per-instance/uim-install.sh
mv /tmp/uim/request.cfg /opt/nimsoft/request.cfg
chown root /var/lib/cloud/scripts/per-instance/uim-install.sh
chmod 755 /var/lib/cloud/scripts/per-instance/uim-install.sh
sleep 10
