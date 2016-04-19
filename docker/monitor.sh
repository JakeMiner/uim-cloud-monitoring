 http://$HUB_IP:8080/setupFiles/unix/nimldr.tar.Z
curl -O http://$HUB_IP:8080/archiveFiles/install_LINUX_23_64.zip
tar -xvf nimldr.tar.Z
cd LINUX_23_64
chmod +x ./nimldr
./nimldr -X -I $HUB_IP -R $(ifconfig $(ip route show |grep default|awk '{print $5}') | grep "inet addr" | awk '{print $2}'|awk -F: '{print $2}') -F /tmp/uim
