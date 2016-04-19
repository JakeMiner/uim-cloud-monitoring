FROM ubuntu
MAINTAINER yourname youremail 
RUN apt-get update && apt-get install -y \
        git \
        curl \
        net-tools \
        nodejs
RUN mkdir /tmp/uim
ADD monitor.sh /tmp/uim/
RUN chmod +x /tmp/uim/monitor.sh
CMD /tmp/uim/monitor.sh
