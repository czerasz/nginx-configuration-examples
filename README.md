# Nginx Configuration Example

## Features

- Maintenance Page

  When the file `/usr/share/nginx/html/maintenance-mode` exists Nginx will return the content of `/usr/share/nginx/html/maintenance.html` together with the status code `503` (service temporarily unavailable).

  The maintenance mode can be enabled through the following HTTP request:

        curl -XPUT -u czerasz:password1234567890 localhost/maintenance-mode -d ''

  The maintenance mode can be disabled with the following HTTP request:

        curl -XDELETE -u czerasz:password1234567890 localhost/maintenance-mode

## Test

To test the configuration run the following helper script:

    ./bin/test.sh

This script is runs test based on [bats](https://github.com/sstephenson/bats) inside the container.

## Usefull Commands

- reload Nginx
    
        kill -HUP `cat /var/run/nginx.pid`

- generate the `/etc/nginx/htpasswd` file with base auth credentials
    
        htpasswd -cb /etc/nginx/htpasswd 'czerasz' 'password1234567890'

## Requirements

- [Docker](https://www.docker.com/)

## Resources

- [Nginx Docker Image](https://github.com/aptible/docker-nginx)
- [Youtube: Test Drive Your Config File!](https://www.youtube.com/watch?v=XGIY9ezIzyE)
