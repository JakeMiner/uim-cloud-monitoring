#set PACKER_LOG=1

packer.exe build -only=amazon-ebs ^
	-var user_name=your email here ^
	-var aws_access_key=your key here ^
	-var aws_secret_key=your key here ^
	-var uim_primary_hub_ip=your UIM ip here ^
	-var uim_primary_hub_dom=your UIM domain here ^
	uimrobot-enabled-linux-image.json
