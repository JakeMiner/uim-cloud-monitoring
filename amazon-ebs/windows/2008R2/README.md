#Explanation of files

##build_windows_ami.bat and build_windows_ami.sh
This script is used to keep credential information out of the [Packer](http://www.packer.io) templates. Update the file with your AWS and UIM information.

##uimrobot-enabled-windows-image.json
This file is a [Packer](http://packer.io) template containing three sections: variables, builders, and provisioners.
The provisioners section runs scripts/Ec2Config.ps1.

##WinRM.ps1
This file is passed to the instance that was launched to provision the AMI. The provisioner being used is WinRM, and this script
ensures that WinRM is configured appropriately.

##scripts/EC2Config.ps1
When an instance is launched to build an AMI, the 
[Amazon EC2Config Service](http://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/UsingConfig_WinAMI.html) runs initial startup tasks
and disables them. For these tasks to run when an instance is launched from our AMI, we need to be re-enabled. The tasks to be 
re-enabled are generating a random password, setting the computer name, and handling user data.

##UserData.ps1
Specify this file as User data when launching an AWS image. The file includes PowerShell commands that will be run by the Amazon EC2ConfigService when the instance starts.

Update the following lines appropriate with your environment. You may leave the existing NEWGROUP as is, or specify your own name.  
`$UIM_PRIMARY_HUB_IP="your ip here"`  
`$NEWGROUP="uim-enabled-security-group"`

If the UIM server will be communicating with the AWS instance over the public IP, uncomment the following line.  
`#Uncomment the following line if the robot/secondary hub will communicate to UIM through the external IP`  
`#Add-Content -Path c:\temp\uim\nms-robot-vars.cfg "robotip_alias=$PUBLIC_IP"`
