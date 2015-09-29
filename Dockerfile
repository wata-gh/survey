FROM centos:centos6.6

RUN yum groupinstall -y "Development Tools"
RUN yum install -y pcre-devel zlib-devel openssl-devel gd-devel ImageMagick ImageMagick-devel
RUN yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/imlib2-1.4.2-5.el6.x86_64.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/imlib2-devel-1.4.2-5.el6.x86_64.rpm
RUN yum install -y tar which

COPY image_server/nginx_install.sh /usr/local/bin/nginx_install.sh
RUN chmod +x /usr/local/bin/nginx_install.sh

RUN /usr/local/bin/nginx_install.sh

COPY image_server/nginx /etc/nginx

# ENTRYPOINT ["/usr/sbin/nginx"]
# CMD ["-c", "/etc/nginx/nginx.conf"]
