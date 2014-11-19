#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/nginx-lua

# install node.js
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y nodejs npm --enablerepo=epel
RUN git clone git://github.com/creationix/nvm.git ~/.node
RUN source ~/.node/nvm.sh
RUN npm install -g forever
RUN npm install -g express


ADD files/etc_init.d_nginx /etc/init.d/nginx
ADD files/nginx.conf /usr/local/nginx/conf/
ADD files/package.json /tmp/
ADD files/app.js /tmp/
ADD files/services.sh /etc/services.sh
RUN chmod +x /etc/services.sh
RUN chmod +x /etc/init.d/nginx
EXPOSE 80
ENTRYPOINT /etc/services.sh

