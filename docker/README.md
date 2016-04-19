The [Dockerfile](https://docs.docker.com/engine/reference/builder/) adds UIM monitoring to a base [Wordpress](https://hub.docker.com/_/wordpress/) container image.

Note that in the Dockerfile the CMD is specified as `/tmp/uim/monitor.sh`. The script `/tmp/uim/monitor.sh` will need to have the final line updated to the original CMD of the base container.

To create an image with uim installed, update your personal information in the Dockerfile, set the HUB_IP environment variable to the IP of your UIM server and run:  
`docker build .`

In order to monitor Docker containers (other than by using the UIM Docker probe), you must configure your container with an externally routable IP.
[This post](http://therning.org/magnus/posts/2015-10-22-000-docker-container-with-ip-address-on-local-network.html) provides information on how to configure containers with externally routable IPs for environment running Docker prior to 1.10. 

[This post](https://blog.jessfraz.com/post/ips-for-all-the-things/) provides information on how to configure containers with externally routable IPs for environment running Docker prior to 1.10.
