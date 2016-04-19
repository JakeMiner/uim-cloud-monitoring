#!/bin/sh

#Update uim-install.sh with the primary hub IP
sed -i "s/uim-primary-hub-ip/${uim_primary_hub_ip}/g" /tmp/uim/uim-install.sh
sed -i "s/uim-primary-hub-ip/${uim_primary_hub_ip}/g" /tmp/uim/ec2_security.sh
sed -i "s/uim-primary-hub-dom/${uim_primary_hub_dom}/g" /tmp/uim/uim-install.sh

#Move uploaded files into place
mkdir -p /opt/nimsoft/robot
mv /tmp/uim/uim-install.sh /var/lib/cloud/scripts/per-instance/uim-install.sh
mv /tmp/uim/ec2_security.sh /var/lib/cloud/scripts/per-instance/ec2_security.sh
mv /tmp/uim/request.cfg /opt/nimsoft/request.cfg
chown root /var/lib/cloud/scripts/per-instance/uim-install.sh
chown root /var/lib/cloud/scripts/per-instance/ec2_security.sh
chmod 755 /var/lib/cloud/scripts/per-instance/uim-install.sh
chmod 755 /var/lib/cloud/scripts/per-instance/ec2_security.sh

#We need Amazon CLI for creating an EC2 security group

#Install Amazon tools 
cd /tmp/uim
curl -s -O http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
mkdir /usr/local/ec2
yum -q -y install unzip
unzip -q ec2-api-tools.zip -d /usr/local/ec2

#Install Java required by Amazon tools
yum -q -y install java
