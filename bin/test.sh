#!/bin/bash

script_dirirectory="$( cd "$( dirname "$0" )" && pwd )"
project_directory=$script_dirirectory/..

echo 'Build the container'
cd $project_directory
docker build --quiet=true -t czerasz/nginx-configuration-example . > /dev/null

echo 'Remove the old container'
# Remove the old container silently
docker rm -f nginx-configuration-example &>/dev/null

echo 'Start the container and run the tests'
# Start a new container
docker run --name nginx-configuration-example \
           --rm=true \
           czerasz/nginx-configuration-example bats /nginx.bats