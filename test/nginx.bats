#!/usr/bin/env bats

wait_for_nginx() {
  # Start Nginx
  nginx &
  
  while ! pgrep -x "nginx: worker process" > /dev/null ;
  do
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

@test "Nginx is installed in version 1.7.7" {
  run /usr/sbin/nginx -v

  [[ "$output" =~ "1.7.7"  ]]
}