# uim-cloud-monitoring
This repository contains information about how to create cloud images instrumented with UIM monitoring. UIM has probes for monitoring cloud environments externally with the [AWS probe](https://docops.ca.com/ca-unified-infrastructure-management-probes/en/alphabetical-probe-articles/aws-amazon-web-services-monitoring), and [Azure probe](https://docops.ca.com/ca-unified-infrastructure-management-probes/en/alphabetical-probe-articles/azure-microsoft-azure-monitoring), and the [Docker probe](https://docops.ca.com/ca-unified-infrastructure-management-probes/en/alphabetical-probe-articles/docker_monitor-docker-monitoring-pre-release). The information here will help ff you are interested in utilizing the local probes such as [CDM](https://docops.ca.com/ca-unified-infrastructure-management-probes/en/alphabetical-probe-articles/cdm-cpu-disk-memory-performance-monitoring), [logmon](https://docops.ca.com/ca-unified-infrastructure-management-probes/en/alphabetical-probe-articles/logmon-log-monitoring), [etc.](https://docops.ca.com/ca-unified-infrastructure-management-probes/en/alphabetical-probe-articles/) within your cloud images.

#amazon-ebs
Utilizes [Packer.io](http://packer.io) for creating AMIs in AWS

#azure-arm
Utilizes [Packer.io](http://packer.io) for creating VHDs in Azure

#docker
Utilizes a [dockerfile](https://docs.docker.com/engine/reference/builder/) and the Docker build command to create a docker image.
