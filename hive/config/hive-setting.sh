#!/bin/bash

/home/hadoop/hadoop/bin/hadoop fs -mkdir /tmp
/home/hadoop/hadoop/bin/hadoop fs -mkdir -p /user/hive/warehouse
/home/hadoop/hadoop/bin/hadoop fs -chmod g+w /tmp
/home/hadoop/hadoop/bin/hadoop fs -chmod g+w /user/hive/warehouse


cd /home/hadoop/hive/bin/
./schematool -initSchema -dbType derby
