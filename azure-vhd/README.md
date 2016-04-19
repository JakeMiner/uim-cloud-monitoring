This directory includes files demonstrating how to provision Azure Virtual Hard Disks (VHDs) with UIM monitoring.

To launch a Linux VM with UIM monitoring enabled, we utilize technology from [Packer by HashiCorp](http://packer.io). This technology launches a VM from a base VHD, provisions the VM with additional files and configuration, creates a new VHD from the VM, and then shuts down the temporary VM. In the Linux example scripts are left that will install and configure UIM monitoring via a [cloud-init](https://cloudinit.readthedocs.org/en/latest/) script on VM launch. For Linux VHD creation ensure that you have the necessary network access to Azure required for the Packer azure-arm provisioner (port 22).

Install packer according to the following [instructions](https://www.packer.io/docs/installation.html).

Next download or clone this repository.

#Building a Linux image 
- `cd amazon-ebs/linux/centos/`
- Update the build_linux_vhd script appropriate for your operating environment your UIM server information and Azure information. Information on gathering the required Azure information is found in the [Packer documentation](https://www.packer.io/docs/builders/azure-setup.html).
- Execute the build_linux_vhd script.

Packer launches a VM from the specified image, provisions the VM with files and scripts, stops the VM, creates and returns the VHD. The output of running build_linux_vhd should look similar to:

$ ./build_linux_vhd.sh
azure-arm output will be in this color.

>==> azure-arm: Preparing builder ...  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm: Creating Azure Resource Manager (ARM) client ...  
>==> azure-arm: Creating resource group ...  
>==> azure-arm:  -> ResourceGroupName : 'packer-Resource-Group-5h5dd163fq'  
>==> azure-arm:  -> Location          : 'West US'  
>==> azure-arm: Validating deployment template ...  
>==> azure-arm:  -> ResourceGroupName : 'packer-Resource-Group-5h5dd163fq'  
>==> azure-arm:  -> DeploymentName    : 'pkrdp5h5dd163fq'  
>==> azure-arm: Deploying deployment template ...  
>==> azure-arm:  -> ResourceGroupName : 'packer-Resource-Group-5h5dd163fq'  
>==> azure-arm:  -> DeploymentName    : 'pkrdp5h5dd163fq'  
>==> azure-arm: Getting the public IP address ...  
>==> azure-arm:  -> ResourceGroupName   : 'packer-Resource-Group-5h5dd163fq'  
>==> azure-arm:  -> PublicIPAddressName : 'packerPublicIP'  
>==> azure-arm:  -> SSHHost             : '40.112.187.60'  
>==> azure-arm: Waiting for SSH to become available...  
>==> azure-arm: Connected to SSH!  
>==> azure-arm: Provisioning with shell script: C:\cygwin64\tmp\packer-shell623269075  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm:  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm: We trust you have received the usual lecture from the local System  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm: Administrator. It usually boils down to these three things:  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm:  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm: #1) Respect the privacy of others.  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm: #2) Think before you type.  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm: #3) With great power comes great responsibility.  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm:  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm: [sudo] password for centos: Delta RPMs disabled because /usr/bin/applydeltarpm not installed.  
>==> azure-arm: Uploading uploads/uim-install.sh => /tmp/uim/uim-install.sh  
>==> azure-arm: Uploading uploads/request.cfg => /tmp/uim/request.cfg  
>==> azure-arm: Pausing 10s before the next provisioner...  
>==> azure-arm: Provisioning with shell script: scripts/install.sh  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;azure-arm: [sudo] password for centos:  
>==> azure-arm: Querying the machine's properties ...  
>==> azure-arm:  -> ResourceGroupName : 'packer-Resource-Group-5h5dd163fq'  
>==> azure-arm:  -> ComputeName       : 'pkrvm5h5dd163fq'  
>==> azure-arm:  -> OS Disk           : 'http://uimpackerbuild.blob.core.windows.net/images/pkros5h5dd163fq.vhd'  
>==> azure-arm: Powering off machine ...  
>==> azure-arm:  -> ResourceGroupName : 'packer-Resource-Group-5h5dd163fq'  
>==> azure-arm:  -> ComputeName       : 'pkrvm5h5dd163fq'  
>==> azure-arm: Capturing image ...  
>==> azure-arm:  -> ResourceGroupName : 'packer-Resource-Group-5h5dd163fq'  
>==> azure-arm:  -> ComputeName       : 'pkrvm5h5dd163fq'  
>==> azure-arm: Deleting resource group ...  
>==> azure-arm:  -> ResourceGroupName : 'packer-Resource-Group-5h5dd163fq'  
>==> azure-arm: Deleting the temporary OS disk ...  
>==> azure-arm:  -> OS Disk             : 'http://uimpackerbuild.blob.core.windows.net/images/pkros5h5dd163fq.vhd'  
>Build 'azure-arm' finished.  

#Launching a VM monitored by UIM
When any VM is launched from the newly created VHD, you should see it show up in your UIM server within a few minutes.

A few steps are required to launch a VM from a VHD image. Information below is taken from [this post](https://github.com/Azure/packer-azure/issues/201) referenced on the Packer.io website.

1. Create a NIC for you VM, and attach it the appropriate Virtual Network and Subnet. Click + New > See all > Search for "Network Interface" > Select "Network interface > Create. Locate the NIC you just created, and copy the Resource ID (located under properties). It will look something similar to "/subscriptions/c34b33c6-7d7b-450f-aa58-2f31561faa8e/resourceGroups/uim/providers/Microsoft.Network/networkInterfaces/uimclient1"
2. Locate the template file and copy the contents. You can find this by going to the resource group that you specified for Packer. Select blobs, the container system, and then navigate to the packer-vmTempplate* file and select Download.
3. Click + New > Template Deployment > Edit Template, and paste the contents of the template over all existing data. Click save.
4. > Edit Parameters - provide appropriate values for your template, you will be prompted for all of values that are required. For networkInterfaceId, enter the Resource ID from step 1.


For more detailed information, please review the README.md files for Linux and Windows  
[azure-vhd/linux/centos/README.md](amazon-ebs/linux/centos/README.md)  

