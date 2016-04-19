This directory includes files demonstrating how to provision AWS Machine Images (AMIs) with UIM monitoring.

To launch a Linux AMI with UIM monitoring enabled, we utilize technology from [Packer by HashiCorp](http://packer.io). This technology launches an instance from a base AMI, provisions the instance with additional files and configuration, creates a new AMI from the instance, and then shuts down the temporary instance. In the Linux examples scripts are left that will install and configure UIM monitoring via a cloud-init script on instance launch. For Linux AMI creation ensure that you have the necessary network access to AWS required for the Packer remote-shell provisioner (port 22).

To launch a Windows AMI with UIM monitoring enables, we simply provide User data during instance creation. Packer can still be utilized and an example Packer template and scripts are provided for completeness. If building a custom AMI with Packer ensure that you have the necessary network access to AWS required for the Packer WinRM provisioner (port 5985).

Install packer according to the following [instructions](https://www.packer.io/docs/installation.html).

Next download or clone this repository.

#Building a Windows image 
- `cd amazon-ebs/windows/2008R2/`
- Update the build_windows_ami script appropriate for your operating environment with your email, [AWS Access Key, and AWS Secret Key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html).
- Execute the build_windows_ami script.

#Building a Linux image 
- `cd amazon-ebs/linux/centos/`
- Update the build_linux_ami script appropriate for your operating environment with your email, [AWS Access Key, AWS Secret Key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html), and IP address of your UIM server.
- Execute the build_linux_ami script.

Packer launches an AWS instance from the specified AMI, provisions the instance with files and scripts, stops the instance, creates and returns the AMI. The output of running build_linux_ami should look similar to:

> ==> amazon-ebs: Prevalidating AMI Name...  
>==> amazon-ebs: Inspecting the source AMI...  
>==> amazon-ebs: Creating temporary keypair: packer 56f0105f-34b5-6503-875c-1ddaee9c7590  
>==> amazon-ebs: Creating temporary security group for this instance...  
>==> amazon-ebs: Authorizing access to port 22 the temporary security group...  
>==> amazon-ebs: Launching a source AWS instance...  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: Instance ID: i-a5abf562  
>==> amazon-ebs: Waiting for instance (i-a5abf562) to become ready...  
>==> amazon-ebs: Waiting for SSH to become available...  
>==> amazon-ebs: Connected to SSH!  
>==> amazon-ebs: Provisioning with shell script: C:\cygwin64\tmp\packer-shell006911391  
>==> amazon-ebs: Uploading uploads/uim-install.sh => /tmp/uim/uim-install.sh  
>==> amazon-ebs: Uploading uploads/request.cfg => /tmp/uim/request.cfg  
>==> amazon-ebs: Uploading uploads/ec2_security.sh => /tmp/uim/ec2_security.sh  
>==> amazon-ebs: Pausing 10s before the next provisioner...  
>==> amazon-ebs: Provisioning with shell script: scripts/install.sh  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: warning: /var/cache/yum/x86_64/7/base/packages/unzip-6.0-15.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: Public key for unzip-6.0-15.el7.x86_64.rpm is not installed  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: Importing GPG key 0xF4A80EB5:  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: Package    : centos-release-7-1.1503.el7.centos.2.8.x86_64 (installed)  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7  
>==> amazon-ebs: Stopping the source instance...  
>==> amazon-ebs: Waiting for the instance to stop...  
>==> amazon-ebs: Creating the AMI: 2016-03-21T15-16-47Z uim-robot-enabled-linux  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: AMI: ami-edd23a8d  
>==> amazon-ebs: Waiting for AMI to become ready...  
>==> amazon-ebs: Adding tags to AMI (ami-edd23a8d)...  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: Adding tag: "uim_monitored": "true"  
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;amazon-ebs: Adding tag: "author": "your email here "  
>==> amazon-ebs: Tagging snapshot: snap-ace4e5f6  
>==> amazon-ebs: Terminating the source AWS instance...  
>==> amazon-ebs: Cleaning up any extra volumes...  
>==> amazon-ebs: Destroying volume (vol-05345bf3)...  
>==> amazon-ebs: Deleting temporary security group...  
>==> amazon-ebs: Deleting temporary keypair...  
>Build 'amazon-ebs' finished.  
>  
>==> Builds finished. The artifacts of successful builds are:  
>--> amazon-ebs: AMIs were created:  
>  
>us-west-2: ami-edd23a8d

#Launching an AWS instance monitored by UIM
When any instance is launched from the newly created AMI, you should see it show up in your UIM server within a few minutes.

You must launch your instance with an [IAM](https://aws.amazon.com/iam/) role that has at least the permissions as specified in the [policy.json](amazon-ebs/security/policy.json) in this repository.

On Windows, in addition to an AMI role, you must specify the User date file [UserData.ps1](amazon-ebs/windows/2008R2/UserData.ps1) at the time of instance creation.

If you are monitoring your AWS instances via the public IP you will need to configure your UIM primary hub to ignore IP security. This can be done with the hubsec_setup_put callback on the hub with the key "ignore_ip” and the value “yes".

For more detailed information, please review the README.md files for Linux and Windows  
[amazon-ebs/linux/centos/README.md](amazon-ebs/linux/centos/README.md)  
[amazon-ebs/windows/WIN2008R2/README.md](amazon-ebs/windows/2008R2/README.md)
