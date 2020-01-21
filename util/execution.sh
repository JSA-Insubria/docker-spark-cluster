#!/bin/bash

cd ..
cd scalabase
./build.sh
cd ..
cd spark
./build.sh
cd ..
cd hive
./build.sh
cd ..
./cluster.sh deploy
