#!/usr/bin/env bats

wait_for_nginx() {
  # Start Nginx
  nginx &
  
  while ! pgrep -xf "nginx: worker process" > /dev/null ;
  do
    echo 'wait for nginx'

    sleep 0.1;
  done
}

maintenance_file_path=/usr/share/nginx/html/maintenance-mode

teardown() {
  pkill nginx || true
  rm -f $maintenance_file_path &> /dev/null
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

  [[ "$result" -eq '502' ]]
}

@test "Nginx should be in maintenance mode if the $maintenance_file_path exists" {
  wait_for_nginx

  touch $maintenance_file_path
  
  run bash -c "curl -s -w '%{http_code}' http://localhost/ -o /dev/null"

  [[ "$output" -eq '503' ]]
}

@test "Allow the client to create the $maintenance_file_path file over HTTP" {
  wait_for_nginx

  # Shouldn't be able to create the maintenance file without authentication
  run bash -c "curl -s -w '%{http_code}' -XPUT localhost/maintenance-mode -d '' -o /dev/null"

  [[ "$output" -eq '401' ]]

  # File shouldn't be created yet
  if [ -f "$maintenance_file_path" ]; then
    [[ 1 -eq 0 ]]
  else
    [[ 0 -eq 0 ]]
  fi

  # Allow with authentication
  run bash -c "curl -s -u czerasz:password1234567890 -w '%{http_code}' -XPUT localhost/maintenance-mode -d '' -o /dev/null"

  echo '---------------------------------------------------------------'
  echo $output
  echo '---------------------------------------------------------------'

  [[ "$output" -eq '201' ]]

  # Check if maintenance file was successfully created
  if [ -f "$maintenance_file_path" ]; then
    [[ 0 -eq 0 ]]
  else
    [[ 1 -eq 0 ]]
  fi
}

@test "Allow the client to remove the $maintenance_file_path file over HTTP" {
  wait_for_nginx

  touch $maintenance_file_path
  chown nginx:nginx $maintenance_file_path

  # Shouldn't be able to delete the maintenance file without authentication
  run bash -c "curl -s -w '%{http_code}' -XDELETE localhost/maintenance-mode -o /dev/null"

  [[ "$output" -eq '401' ]]

  # File shouldn't be deleted yet
  if [ -f "$maintenance_file_path" ]; then
    [[ 0 -eq 0 ]]
  else
    [[ 1 -eq 0 ]]
  fi

  # Allow with authentication
  run bash -c "curl -s -u czerasz:password1234567890 -w '%{http_code}' -XDELETE localhost/maintenance-mode -o /dev/null"

  echo '---------------------------------------------------------------'
  echo $output
  echo '---------------------------------------------------------------'

  # File should be deleted
  if [ -f "$maintenance_file_path" ]; then
    [[ 1 -eq 0 ]]
  else
    [[ 0 -eq 0 ]]
  fi

  [[ "$output" -eq '204' ]]
}