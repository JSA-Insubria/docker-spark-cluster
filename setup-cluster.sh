#!/bin/bash

set -x

docker network create --driver bridge sparknet

NNODE=$([ $# -eq 1 ] && echo "$1" || echo "5")

echo $NNODE

echo 'nodemaster' > config/hadoop/workers
for i in $(seq -w 2 $NNODE); do
  echo node$i >> config/hadoop/workers
done


# setup nodemaster
mkdir -p $PWD/tests/nodemaster
docker run --rm -dP -p 10000:10000 --network sparknet \
  --name nodemaster \
  -h nodemaster \
  -v $PWD/tests/nodemaster:/home/hadoop/data \
  -v $PWD/config/hadoop:/home/hadoop/hadoop/etc/hadoop \
  -v $PWD/test-data:/home/hadoop/test-data \
  -it res-drl-docker-local.artifactory.swg-devops.com/database-testing/hivebase
docker exec -u hadoop -it nodemaster ln -s /home/hadoop/hadoop/etc/hadoop/workers /home/hadoop/spark/conf/slaves
docker exec -u hadoop -it nodemaster chmod +x /home/hadoop/.ssh

# setup datanodes
for i in $(seq -w 2 $NNODE); do
  mkdir -p $PWD/tests/node$i
  docker run --rm -dP --network sparknet \
    --name node$i \
    -h node$i \
    -v $PWD/tests/node$i:/home/hadoop/data \
    -v $PWD/config/hadoop:/home/hadoop/hadoop/etc/hadoop \
    -it res-drl-docker-local.artifactory.swg-devops.com/database-testing/sparkbase
    docker exec -u hadoop -it node$i ln -s /home/hadoop/hadoop/etc/hadoop/workers /home/hadoop/spark/conf/slaves
    docker exec -u hadoop -it node$i chmod +x /home/hadoop/.ssh
    docker exec -it node$i chown hadoop:hadoop /home/hadoop/data
done



docker exec -it nodemaster chown hadoop:hadoop /home/hadoop/data
docker exec -u hadoop -it nodemaster hadoop/bin/hdfs namenode -format
docker exec -u hadoop -it nodemaster hadoop/sbin/start-dfs.sh
docker exec -u hadoop -it nodemaster hadoop/sbin/start-yarn.sh
docker exec -u hadoop -it nodemaster rm hive/lib/guava-19.0.jar
docker exec -u hadoop -it nodemaster cp hadoop/etc/hadoop/guava-27.0-jre.jar hive/lib
docker exec -u hadoop -it nodemaster ./hive-setting.sh

#docker exec -u hadoop -it nodemaster hive/
