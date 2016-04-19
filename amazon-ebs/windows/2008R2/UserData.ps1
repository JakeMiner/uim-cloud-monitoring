<powershell>
$UIM_PRIMARY_HUB_IP="your ip here"
$NEWGROUP="uim-enabled-security-group"

####
# Begin setup EC2 Security Group
####

Import-Module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"

$EC2_AVAIL_ZONE = (Invoke-WebRequest -UseBasicParsing http://instance-data/latest/meta-data/placement/availability-zone )
$EC2_REGION =  $EC2_AVAIL_ZONE -replace '[a-z]*$', ''
$AMIID = (Invoke-WebRequest -UseBasicParsing http://instance-data/latest/meta-data/ami-id )
$INSTANCE_ID = (Invoke-WebRequest -UseBasicParsing http://instance-data/latest/meta-data/instance-id )

Set-DefaultAWSRegion -Region $EC2_REGION


#Create the security group if it doesn't already exist and add the ingress rule
try {
  $GROUPID = (Get-EC2SecurityGroup -GroupName $NEWGROUP |select -ExpandProperty GroupID)
} catch {
  $GROUPID = (New-EC2SecurityGroup -GroupName $NEWGROUP -GroupDescription "EC2-VPC from $AMIID")
  
  #Add the ingress rule
  $cidrBlocks = New-Object 'collections.generic.list[string]'
  $cidrBlocks.add("${UIM_PRIMARY_HUB_IP}/32")
  $ipPermissions = New-Object Amazon.EC2.Model.IpPermission 
  $ipPermissions.IpProtocol = "tcp" 
  $ipPermissions.FromPort = 48000 
  $ipPermissions.ToPort = 48099
  $ipPermissions.IpRanges = $cidrBlocks
  Grant-EC2SecurityGroupIngress -GroupName $NEWGROUP -IpPermissions $ipPermissions
}

#Get list of groups this instance is a part of
$GROUPNAMES = (Invoke-WebRequest -UseBasicParsing http://instance-data/latest/meta-data/security-groups )

#Convert group names to group IDs
$GROUPIDS = New-Object System.Collections.Generic.List[System.Object]
$GROUPIDS.Add($GROUPID)
ForEach ($GROUPNAME in $GROUPNAMES.Content.Split()) {
    $GROUPID = (Get-Ec2SecurityGroup -GroupName $GROUPNAME |select -ExpandProperty GroupId)
    $GROUPIDS.Add($GROUPID)
}

#Modify the instance to set the group(s) membership
Edit-EC2InstanceAttribute -InstanceId $INSTANCE_ID -Group $GROUPIDS

####
# End setup EC2 Security Group
####

####
# Add Windows firewall rule
####
netsh advfirewall firewall add rule name="Allow UIM traffic" dir=in action=allow protocol=TCP localport=48000-48099

####
# Begin install UIM robot
####

$PUBLIC_IP = ( Invoke-WebRequest -UseBasicParsing http://instance-data/latest/meta-data/public-ipv4 )
echo "Nimbus: Found public IP - $PUBLIC_IP"

$LOCAL_IP =( Invoke-WebRequest -UseBasicParsing http://instance-data/latest/meta-data/local-ipv4 )
echo "Nimbus: Found local IP - $LOCAL_IP"

New-Item c:\temp\uim -itemtype directory
cd c:\temp\uim

#Add to the request for probe deployment
Add-Content -Path c:\temp\uim\request.cfg "<distribution request>"
Add-Content -Path c:\temp\uim\request.cfg "  packages = cdm"
Add-Content -Path c:\tema\uim\request.cfg "</distribution request>"

#Add to the robot configuration file the location of the hub and robot
Add-Content -Path c:\temp\uim\nms-robot-vars.cfg "hubip=${UIM_PRIMARY_HUB_IP}"
#Uncomment the following line if the robot/secondary hub will communicate to UIM through the external IP
#Add-Content -Path c:\temp\uim\nms-robot-vars.cfg "robotip_alias=$PUBLIC_IP"

#Download and install the UIM robot installation package.
Invoke-WebRequest -UseBasicParsing -OutFile nimsoft-robot-x64.exe "http://${UIM_PRIMARY_HUB_IP}:8080/setupFiles/nimsoft-robot-x64.exe"
Start-Process c:\temp\uim\nimsoft-robot-x64.exe /silent -NoNewWindow -Wait

#Install optional probes
Move-Item "c:\temp\uim\request.cfg" "c:\Program Files\Nimsoft\request.cfg"
Stop-Service "NimbusWatcherService"
Start-Service "NimbusWatcherService"

####
# End install UIM robot
####
</powershell>
