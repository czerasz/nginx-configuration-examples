#!/usr/bin/env bats

wait_for_nginx() {
  # Start Nginx
  nginx &
  
  while ! pgrep -xf "nginx: worker process" > /dev/null ;
  do
    echo 'sleep'
    sleep 0.1;
  done
}

teardown() {
  pkill nginx || true
}

@test "Nginx binary is found in $PATH" {
  run which nginx

  [ "$status" -eq 0 ]
}

@test "Nginx is installed in version 1.7.9" {
  run /usr/sbin/nginx -v

  [[ "$output" =~ "1.7.9"  ]]
}

@test "Upstream server shouldn't be available" {
  wait_for_nginx

  result="$(curl -Is http://localhost/ | head -n1 | awk '{print $2}')"

  [[ $result -eq '502' ]]
}