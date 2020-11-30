#!/bin/bash

path=$1
time=$2

java -jar Algorithm-1.0-jar-with-dependencies.jar $path $time
cd algorithm_data/solutions
find -name 'FilesLocation_*.txt' | sort -V | tail -1 | xargs cp -t ../../../test-data/
mv ../../../test-data/FilesLocation_*.txt ../../../test-data/FilesLocation.txt
