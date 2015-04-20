# Nginx Configuration Example

## Features

- Maintenance Page

  When the file `/usr/share/nginx/html/maintenance.html` exists Nginx will return its content for all requests with the status code `503` (service temporarily unavailable).

  The maintenance mode can be enabled through the following HTTP request:

        curl -XPUT localhost/maintenance.html -d ''

## Test

To test the configuration run the following helper script:

    ./bin/test.sh

This script is runs test based on [bats](https://github.com/sstephenson/bats) inside the container.

## Usefull Commands

- reload Nginx
    
        kill -HUP `cat /var/run/nginx.pid`

## Requirements

- [Docker](https://www.docker.com/)

## Resources

- [Nginx Docker Image](https://github.com/aptible/docker-nginx)
- [Youtube: Test Drive Your Config File!](https://www.youtube.com/watch?v=XGIY9ezIzyE)
