#!/bin/sh

NEWGROUP="uim-enabled-security-group"

#Setup environment variables
cd /usr/local/ec2/*
export EC2_HOME=$PWD
export PATH=$PATH:$EC2_HOME/bin
export JAVA_HOME=$(dirname $(dirname $(update-alternatives --display java |grep "link currently"| awk '{print $5}')))

#Get necessary instance information
export EC2_AVAIL_ZONE=`curl -s http://instance-data/latest/meta-data/placement/availability-zone`
export EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
unset EC2_URL ; export EC2_URL=https://$(ec2-describe-regions $EC2_REGION |awk '{print $3}')
export MACID=$(curl -s http://instance-data/latest/meta-data/network/interfaces/macs/)
export VPCID=$(curl -s http://instance-data/latest/meta-data/network/interfaces/macs/$MACID/vpc-id)
export AMIID=$(curl -s http://instance-data/latest/meta-data/ami-id)
export INSTANCE_ID=$(curl -s http://instance-data/latest/meta-data/instance-id)

#Get list of groups this instance is a part of
export GROUPNAMES=$(curl -s http://instance-data/latest/meta-data/security-groups |tr '\n' ' ')

#Convert the group names to group IDs
unset GROUPIDS ; for GROUPNAME in $GROUPNAMES; do GROUPIDS="$GROUPIDS -g "$(ec2-describe-group $GROUPNAME|head -1|awk '{print $2}') ; done

#If it doesn't already exist create a group with necessary ingress rule
export GROUPID=$(ec2-describe-group $NEWGROUP |grep GROUP| awk '{print $2}')
if [ -z "$GROUPID" ]; then
  export GROUPID=$(ec2-create-group $NEWGROUP -d "EC2-VPC from $AMIID" -c $VPCID |awk '{print $2}')
  ec2-authorize $GROUPID -P TCP -p 48000-48099 -s uim-primary-hub-ip/32
fi

#Add our new group to the list of IDs
GROUPIDS="$GROUPIDS -g $GROUPID"

#modify the instance to set the group(s) membership
ec2-modify-instance-attribute $INSTANCE_ID $GROUPIDS
