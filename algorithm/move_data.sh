#!/bin/bash

cd ..
cp -r results/data algorithm/algorithm_data/original
cd algorithm
java -jar Algorithm-1.0-jar-with-dependencies.jar original 1m
cd algorithm_data/solutions
find -name 'FilesLocation_*.txt' | sort -V | tail -1 | xargs cp -t ../../../test-data/
mv ../../../test-data/FilesLocation_*.txt ../../../test-data/FilesLocation.txt
