#!/bin/sh

cd /root
curl -o'nginx-1.9.5.tar.gz' 'http://nginx.org/download/nginx-1.9.5.tar.gz'
/bin/tar zxvf nginx-1.9.5.tar.gz
ls -l nginx-1.9.5.tar.gz
cd nginx-1.9.5
git clone https://github.com/cubicdaiya/ngx_small_light.git
cd ngx_small_light/
./setup --with-imlib2 --with-gd
ngx_small_light=`pwd`
cd ..

yum install -y libunwind perl-ExtUtils-Embed gperftools gperftools-libs gperftools-devel libxslt libxslt-devel
./configure \
--add-module=./ngx_small_light \
--prefix=/usr/share/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
--http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
--http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
--http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
--http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/subsys/nginx \
--user=root \
--group=root \
--with-file-aio \
--with-ipv6 \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module \
--with-http_image_filter_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_stub_status_module \
--with-http_perl_module \
--with-mail \
--with-mail_ssl_module \
--with-pcre \
--with-debug \
--with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' \
--with-ld-opt=' -Wl,-E'

make
make install

mkdir /etc/nginx/conf.d
mkdir -p /var/lib/nginx/tmp
