#!/bin/bash

set -x

for x in $(docker ps -a | tail -n +2 | awk '{print $1}'); do
  docker kill $x
  docker rm $x
done
