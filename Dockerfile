FROM centos:7.5.1804

ENV NGINX_VERSION 1.14.0
ENV HTTP_FLV_VERSION 1.2.4
ENV WORK_DIR /root
WORKDIR $WORK_DIR

COPY nginx-$NGINX_VERSION.tar.gz $WORK_DIR
COPY nginx-http-flv-module-$HTTP_FLV_VERSION.tar.gz  $WORK_DIR

RUN yum install -y gcc pcre pcre-devel openssl openssl-devel && cd $WORK_DIR && tar -zxvf nginx-$NGINX_VERSION.tar.gz  \
 && tar -zxvf nginx-http-flv-module-$HTTP_FLV_VERSION.tar.gz \
 && cd nginx-$NGINX_VERSION && ./configure --add-module=$WORK_DIR/nginx-http-flv-module-$HTTP_FLV_VERSION/  \
 && make && make install && rm -f /usr/local/nginx/conf/nginx.conf

COPY nginx.conf /usr/local/nginx/conf/
COPY demo /var/www

EXPOSE 80 1935

STOPSIGNAL SIGTERM

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
