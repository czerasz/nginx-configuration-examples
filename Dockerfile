FROM nginx:1.7.9

# Set the reset cache variable
ENV REFRESHED_AT 2015-04-20

# Update repositories lists and install required tools and libraries
RUN apt-get update
RUN apt-get install -y wget curl git tree vim htop strace procps

# Install bats testing framework
RUN git clone https://github.com/sstephenson/bats.git /tmp/bats && cd /tmp/bats && ./install.sh /usr/local

# Create maintenance content file - this will be returned in maintenance mode
RUN echo 'Site in maintenance' > /usr/share/nginx/html/maintenance.html

# Nginx owns the web content directory - required to save the maintenance file by WebDAV
RUN chown -R nginx:nginx /usr/share/nginx/html/

# Add configuration files
ADD ./config/nginx.conf /etc/nginx/nginx.conf
ADD ./config/maintenance-page.conf /etc/nginx/maintenance-page.conf

# Add the base auth credentials
ADD ./config/htpasswd /etc/nginx/htpasswd

# Add test spec
ADD ./test/nginx.bats /
