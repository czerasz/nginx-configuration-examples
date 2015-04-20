#!/bin/bash

script_dirirectory="$( cd "$( dirname "$0" )" && pwd )"
project_directory=$script_dirirectory/..

cd $project_directory
docker build -t czerasz/nginx-configuration-example .

# Remove the old container silently
docker rm -f nginx-configuration-example &>/dev/null

# Start a new container
docker run --name nginx-configuration-example \
           --rm=true \
           czerasz/nginx-configuration-example bats /nginx.bats