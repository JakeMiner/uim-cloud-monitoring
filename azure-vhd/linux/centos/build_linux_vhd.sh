#export PACKER_LOG=1

packer build -only=azure-arm\
	-var 'uim_primary_hub_ip=your UIM ip here' \
	-var 'uim_primary_hub_dom=your UIM domain here' \
	-var 'ssh_password=your password here' \
	-var 'client_id=your client id here' \
	-var 'client_secret=your client secret here' \
	-var 'subscription_id=your subscription id here' \
	-var 'tenant_id=your tenant id here' \
	uimrobot-enabled-linux-image.json
