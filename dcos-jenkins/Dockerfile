FROM mesosphere/jenkins-dind:0.7.0-ubuntu

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
	&& apt-get install -y nodejs
	
RUN npm install -g typescript

ENV NODE_PATH=/usr/lib/node_modules/
	