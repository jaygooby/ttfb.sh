#!/usr/bin/env bats
#
# To skip a test, just uncomment the # skip line

@test "-? switch" {
  # skip
  run ./ttfb -?
  [[ "$output" =~ "Usage: " ]]
}

@test "Invalid switch" {
  # skip
  run ./ttfb -Z

  [ $status -ne 0 ]
  [[ "$output" =~ "Usage: " ]]
}

@test "-d logs requests to ./curl.log" {
  # skip
  rundir="$(mktemp -d)"
  pwd="$PWD"
  cd "$rundir" && run "$pwd/ttfb" -d example.com
  [ $status -eq 0 ]
  [ -f "$rundir/curl.log" ]
}

@test "-l logs to specific file" {
  # skip
  rundir="$(mktemp -d)"
  logdir="$(mktemp -d)"
  pwd="$PWD"
  cd "$rundir" && run "$pwd/ttfb" -l "$logdir/log.log" example.com
  [ $status -eq 0 ]
  [ -f "$logdir/log.log" ]
}

@test "-l exits if the path the custom log file doesn't exist" {
  # skip
  rundir="$(mktemp -d)"
  logdir="$(mktemp -d)"
  rmdir "$logdir"
  pwd="$PWD"
  cd "$rundir" && run "$pwd/ttfb" -l "$logdir/log.log" example.com
  [ $status -eq 1 ]
}

@test "-n expects an argument" {
  # skip
  run ./ttfb -n example.com
  [ $status -ne 0 ]
  [[ "$output" =~ "Usage: " ]]
}

@test "-n runs test multiple times" {
  # skip
  run ./ttfb -n 3 example.com
  [ $status -eq 0 ]
  [[ "$output" =~ "..." ]]
  [[ "$output" =~ "fastest" ]]
}

@test "can test multiple urls" {
  # skip
  run ./ttfb example.com example.com/hello-world
  [ $status -eq 0 ]
  [[ "$output" =~ "example.com" ]]
  [[ "$output" =~ "example.com/hello-world" ]]
}

@test "can test multiple urls multiple times" {
  # skip
  run ./ttfb -n 3 example.com example.com/hello-world
  [ $status -eq 0 ]
  [[ "$output" =~ "..." ]]
  [[ "$output" =~ "example.com" ]]
  [[ "$output" =~ "example.com/hello-world" ]]
}

@test "-d logs requests to multiple urls to multiple log files" {
  # skip
  rundir="$(mktemp -d)"
  pwd="$PWD"
  cd "$rundir" && run "$pwd/ttfb" -d example.com example.com/hello-world
  [ $status -eq 0 ]
  [ -f "$rundir/example_com-curl.log" ]
  [ -f "$rundir/example_com_hello_world-curl.log" ]
}

@test "-l logs requests to multiple urls to multiple custom log files" {
  # skip
  rundir="$(mktemp -d)"
  pwd="$PWD"
  cd "$rundir" && run "$pwd/ttfb" -l "$rundir/custom.log" example.com example.com/hello-world
  [ $status -eq 0 ]
  [ -f "$rundir/example_com-custom.log" ]
  [ -f "$rundir/example_com_hello_world-custom.log" ]
}

@test "-d logs multiple requests to multiple urls to multiple log files" {
  # skip
  rundir="$(mktemp -d)"
  pwd="$PWD"
  cd "$rundir" && run "$pwd/ttfb" -n2 -d example.com example.com/hello-world
  [ $status -eq 0 ]
  [ -f "$rundir/example_com-curl.log" ]
  [ -f "$rundir/example_com_hello_world-curl.log" ]
  [ $(grep " 200 OK" "$rundir/example_com-curl.log" | wc -l) -eq 2 ]
  [ $(grep " 404 Not Found" "$rundir/example_com_hello_world-curl.log" | wc -l) -eq 2 ]
}

@test "-d logs multiple requests to multiple urls to multiple custom log files" {
  # skip
  rundir="$(mktemp -d)"
  pwd="$PWD"
  cd "$rundir" && run "$pwd/ttfb" -n2 -l "$rundir/custom.log" example.com example.com/hello-world
  [ $status -eq 0 ]
  [ -f "$rundir/example_com-custom.log" ]
  [ -f "$rundir/example_com_hello_world-custom.log" ]
  [ $(grep " 200 OK" "$rundir/example_com-custom.log" | wc -l) -eq 2 ]
  [ $(grep " 404 Not Found" "$rundir/example_com_hello_world-custom.log" | wc -l) -eq 2 ]
}

@test "pass custom curl options via our -o option" {
  # This test passes -k to curl, so it can successfully
  # call https://self-signed.badssl.com which has a self-signed certificate
  # which would normally result in a fail
  # skip
  run "$pwd/ttfb" -o "-k" https://self-signed.badssl.com
  [[ "$output" != "0" ]]
}
