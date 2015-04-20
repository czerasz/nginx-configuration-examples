FROM nginx:1.7.9

# Set the reset cache variable
ENV REFRESHED_AT 2015-04-20

# Update repositories lists and install required tools and libraries
RUN apt-get update
RUN apt-get install -y wget curl git tree vim htop strace procps

# Install bats testing framework
RUN git clone https://github.com/sstephenson/bats.git /tmp/bats && cd /tmp/bats && ./install.sh /usr/local

# Add configuration files
ADD ./config/nginx.conf /etc/nginx/nginx.conf

# Add test spec
ADD ./test/nginx.bats /
