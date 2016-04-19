#!/bin/sh

#export PACKER_LOG=1

packer build -only=amazon-ebs\
	-var 'user_name=your email here' \
	-var 'aws_access_key=your key here' \
	-var 'aws_secret_key=your key here' \
	uimrobot-enabled-windows-image.json
