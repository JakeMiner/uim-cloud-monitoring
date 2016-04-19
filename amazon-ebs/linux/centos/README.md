#Explanation of files

##build_linux_ami.bat & build_linux_ami.sh
This script is used to keep credential information out of the [Packer](http://www.packer.io) templates. Update the file with your AWS and UIM information.

##uimrobot-enabled-linux-image.json
This file is a [Packer](http://packer.io) template containing three sections, variables, builders, and provisioners.
The provisioners section creates a temporary directory, uploads three files to that directory and then runs scripts/install.sh.

##scripts/install.sh
This script updates the uploaded file `uim-install.sh` with the IP of the UIM server.

Next `uim-install.sh` and `ec2_security.sh` are moved into the `/var/lib/cloud/scripts/per-instance` directory. This ensures that cloud-init executes these scripts once on instance creation. When your instance is created you can monitor the output of your cloud-init scripts in `/var/log/cloud-init-output.log`.

Next Amazon CLI tools are downloaded and installed, and finally Java which is required by Amazon CLI tools is installed.

##uploads/ec2_security.sh
This script utilizes Amazon IAM Roles to create an AWS Security Group with the recommended ingress rules for UIM monitoring. The Security Group is then added to the instance. The Policy required for the Role can be found in the security directory of this repository. This script is optional, though if not used, another method must be used to add the necessary ingress rule to the instance. The recommended ingress rule is to allow incoming traffic from your UIM server on ports 48000-48099.

##uploads/uim-install.sh
This script downloads the robot from the UIM server and installs it. By default the script will install a UIM robot connecting to the UIM server over it's VPC interface. If you would like to install a secondary hub, or utilize the external interface instead, comment out the line, and uncomment one of the other lines appropriate to your use case.

`#Use the first line to install only a robot, or the second to install a secondary hub`  
`./nimldr -X -I uim-primary-hub-ip -R $LOCAL_IP -F /tmp/uim`  
`#./nimldr -i -X -D uim-primary-hub-dom -I uim-primary-hub-ip -R $LOCAL_IP -A $PUBLIC_IP -F /tmp/uim`  

`#Use the following lines instead if the robot/secondary hub will communicate to UIM through the external IP`  
`#./nimldr -X -I uim-primary-hub-ip -R $LOCAL_IP -A $PUBLIC_IP -F /tmp/uim`  
`#./nimldr -i -X -D uim-primary-hub-dom -I uim-primary-hub-ip -R $LOCAL_IP -A $PUBLIC_IP -F /tmp/uim`  

An explanation of the nimldr flags can be found on the [CA WIKI](http://https://docops.ca.com/display/UIM83/Flags+for+nimldr).

##uploads/request.cfg
When a UIM robot starts and finds this file in the UIM installation directory it makes a request to the server to install the specified probes. In this example we are requesting the CDM probe to be installed. Multiple packages are comma separated. e.g.

`packages = cdm,dirscan,logmon`
