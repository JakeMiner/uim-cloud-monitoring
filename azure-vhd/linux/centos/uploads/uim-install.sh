#!/bin/sh

#Leave a tracefile
touch /tmp/firstRun

LOCAL_IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
echo "Nimbus: Found local IP - $LOCAL_IP"

#Pull down nimldr and the installation media from the hub
cd /tmp/uim
curl -O http://uim-primary-hub-ip:8080/setupFiles/unix/nimldr.tar.Z
curl -O http://uim-primary-hub-ip:8080/archiveFiles/install_LINUX_23_64.zip
tar -xvf nimldr.tar.Z
cd LINUX_23_64
chmod +x ./nimldr

#Use the first line to install only a robot, or the second to install a secondary hub
./nimldr -X -I uim-primary-hub-ip -R $LOCAL_IP -F /tmp/uim
#./nimldr -i -X -D uim-primary-hub-dom -I uim-primary-hub-ip -R $LOCAL_IP -F /tmp/uim
