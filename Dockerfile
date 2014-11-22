#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/nginx-lua

RUN wget https://raw.githubusercontent.com/typista/docker-nginx-nodejs/master/files/etc_init.d_nginx -O /root/etc_init.d_nginx && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-nodejs/master/files/nginx.conf -O /root/nginx.conf && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-nodejs/master/files/services.sh -O /root/services.sh && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-nodejs/master/files/package.json -O /tmp/package.json && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-nodejs/master/files/app.js -O /tmp/app.js && \
	rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
	yum install -y nodejs npm --enablerepo=epel && \
	git clone git://github.com/creationix/nvm.git ~/.node && \
	source ~/.node/nvm.sh && \
	npm install -g grunt-cli && \
	npm install -g forever && \
	npm install -g express && \
	cp /root/etc_init.d_nginx /etc/init.d/nginx && \
	cp /root/services.sh /etc/services.sh && \
	cp /root/nginx.conf /usr/local/nginx/conf/nginx.conf && \
	chmod +x /etc/init.d/nginx && \
	chmod +x /etc/services.sh

EXPOSE 80
ENTRYPOINT /etc/services.sh

