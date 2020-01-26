#!/bin/bash

source .bashrc


hdfs dfsadmin -safemode leave
echo ">> mkdir /apps"
hdfs dfs -mkdir -p /apps/tez
echo ">> cp /tez"
hadoop fs -copyFromLocal /home/hadoop/tez/share/tez.tar.gz /apps/tez/
echo ">> chmod /apps/tez"
hadoop fs -chmod g+w /apps/tez
echo ">> chmod /apps/tez/tez.tar.gz"
hadoop fs -chmod g+w /apps/tez/tez.tar.gz



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
