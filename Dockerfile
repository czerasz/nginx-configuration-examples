FROM ubuntu

# Set the reset cache variable
ENV REFRESHED_AT 2015-04-20

WORKDIR /tmp/nginx-installation

# Update repositories lists and install required tools and libraries
RUN apt-get update
RUN apt-get install -y wget curl git tree vim htop strace build-essential libpcre3 libpcre3-dev libssl-dev

# Download and extract Nginx
# Get the actual Nginx version number/link from: http://nginx.org/en/download.html
ENV nginx_version 1.6.2
# ENV nginx_version 1.7.10
RUN wget http://nginx.org/download/nginx-$nginx_version.tar.gz && \
    tar -xzvf nginx-$nginx_version.tar.gz && \
    rm -f ./nginx-$nginx_version.tar.gz

# Change directory to 
WORKDIR /tmp/nginx-installation/nginx-$nginx_version

# Configure using ubuntu's configuration
RUN ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-file-aio \
    --with-http_spdy_module \
    --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-z,relro -Wl,--as-needed' \
    --with-ipv6 && \
    make && \
    make install

RUN adduser --system --no-create-home --disabled-login --disabled-password --group nginx && \
    mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp

# Install bats testing framework
RUN git clone https://github.com/sstephenson/bats.git /tmp/bats && cd /tmp/bats && ./install.sh /usr/local

# Add configuration files
ADD ./config/nginx.conf /etc/nginx/nginx.conf

# Add test spec
ADD ./test/nginx.bats /

EXPOSE 80

# Define default command.
CMD ["nginx"]
