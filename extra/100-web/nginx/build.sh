#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/logger.sh
arNginxSrcDir=/usr/local/src

if [[ ! -e /etc/nginx ]]; then
    # hack to create the file structure n shit cause im lazy
    sudo apt-get install -qqy nginx
    cp /etc/systemd/system/multi-user.target.wants/nginx.service /tmp/nginx.service
    sudo apt-get remove -qqy nginx
    sudo mv /tmp/nginx.service /etc/systemd/system/nginx.service
    sudo apt-get autoremove
fi

if [[ ! -e /lib/systemd/system/nginx.service ]]; then
    cp $HOME/.adryd/extra/100-web/nginx/nginx.service /lib/systemd/system/nginx.service
fi

module='nginx-build'

log 3 $module 'Installing dependencies'
sudo apt-get install -qqy mercurial make gcc libmaxminddb0 libmaxminddb-dev libpcre3 libpcre3-dev openssl libssl-dev zlib1g zlib1g-dev libxslt1.1 libxslt1-dev

# headers-more-nginx-module
log 3 $module 'Fetching headers-more-nginx-module'
if [[ ! -e $arNginxSrcDir/headers-more-nginx-module ]]; then
   sudo git clone https://github.com/openresty/headers-more-nginx-module $arNginxSrcDir/headers-more-nginx-module -q
fi
cd $arNginxSrcDir/headers-more-nginx-module
sudo git pull --ff-only -q

# ngx_http_geoip2_module
log 3 $module 'Fetching ngx_http_geoip2_module'
if [[ ! -e $arNginxSrcDir/ngx_http_geoip2_module ]]; then
    sudo git clone https://github.com/leev/ngx_http_geoip2_module $arNginxSrcDir/ngx_http_geoip2_module -q
fi
cd $arNginxSrcDir/ngx_http_geoip2_module
sudo git pull --ff-only -q

# ngx_brotli
log 3 $module 'Fetching ngx_brotli'
if [[ ! -e $arNginxSrcDir/ngx_brotli ]]; then
    sudo git clone https://github.com/google/ngx_brotli $arNginxSrcDir/ngx_brotli -q
    cd $arNginxSrcDir/ngx_brotli
    sudo git submodule update --init -q
fi
cd $arNginxSrcDir/ngx_brotli
sudo git pull --ff-only -q
sudo git submodule update -q

# nginx-dav-ext-module
log 3 $module 'Fetching nginx-dav-ext-module'
if [[ ! -e $arNginxSrcDir/nginx-dav-ext-module ]]; then
    sudo git clone https://github.com/arut/nginx-dav-ext-module $arNginxSrcDir/nginx-dav-ext-module -q
fi
cd $arNginxSrcDir/nginx-dav-ext-module
sudo git pull --ff-only -q

# nginx
log 3 $module 'Fetching nginx'
if [[ ! -e $arNginxSrcDir/nginx ]]; then
    cd $arNginxSrcDir
    sudo hg clone http://hg.nginx.org/nginx
fi
cd $arNginxSrcDir/nginx
sudo hg pull
log 3 $module 'Configuring'
sudo ./auto/configure --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-Cjs4TR/nginx-1.14.2=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/sbin/nginx 
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/run/nginx.pid \
    --modules-path=/usr/lib/nginx/modules \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --add-module=/usr/local/src/ngx_brotli \
    --add-module=/usr/local/src/ngx_http_geoip2_module \
    --add-module=/usr/local/src/headers-more-nginx-module \
    --add-module=/usr/local/src/nginx-dav-ext-module
log 3 $module 'Building'
sudo make
log 3 $module 'Installing'
sudo make install

cd /etc/nginx
log 3 $module 'Tidying up'
sudo rm -rf fastcgi.conf fastcgi_params html mime.types.default nginx.conf.default scgi_params.default uwsgi_params.default fastcgi.conf.default fastcgi_params.default koi-utf koi-win scgi_params uwsgi_params modules-enabled proxy_params snippets sites-available sites-enabled

log 3 $module 'Restarting nginx service'
sudo systemctl restart nginx

--with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-Cjs4TR/nginx-1.14.2=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_xslt_module=dynamic --with-stream=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module --with-mail=dynamic --with-mail_ssl_module --add-dynamic-module=/build/nginx-Cjs4TR/nginx-1.14.2/debian/modules/http-auth-pam --add-dynamic-module=/build/nginx-Cjs4TR/nginx-1.14.2/debian/modules/http-dav-ext --add-dynamic-module=/build/nginx-Cjs4TR/nginx-1.14.2/debian/modules/http-echo --add-dynamic-module=/build/nginx-Cjs4TR/nginx-1.14.2/debian/modules/http-upstream-fair --add-dynamic-module=/build/nginx-Cjs4TR/nginx-1.14.2/debian/modules/http-subs-filter
