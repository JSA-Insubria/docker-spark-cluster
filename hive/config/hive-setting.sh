#!/bin/bash

source .bashrc

echo ">> mkdir /tmp"
/home/hadoop/hadoop/bin/hadoop fs -mkdir /tmp
echo ">> mkdir /user/hive/warehouse"
/home/hadoop/hadoop/bin/hadoop fs -mkdir -p /user/hive/warehouse
echo ">> chmod /tmp"
/home/hadoop/hadoop/bin/hadoop fs -chmod g+w /tmp
echo ">> chmod /user/hive/warehouse"
/home/hadoop/hadoop/bin/hadoop fs -chmod g+w /user/hive/warehouse
echo ">> initSchema"
/home/hadoop/hive/bin/schematool -initSchema -dbType derby
