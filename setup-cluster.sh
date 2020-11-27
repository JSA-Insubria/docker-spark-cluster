#!/bin/bash

set -x

docker network create --driver bridge sparknet

echo 'nodemaster' > config/workers
for i in $(seq -w 2 5); do
  echo node$i >> config/workers
done

# setup nodemaster
mkdir $PWD/tests/nodemaster
docker run --rm -dP -p 10000:10000 --network sparknet \
  --name nodemaster \
  -h nodemaster \
  -v $PWD/tests/nodemaster:/home/hadoop/data \
  -v $PWD/config:/home/hadoop/hadoop/etc/hadoop \
  -it res-drl-docker-local.artifactory.swg-devops.com/database-testing/hivebase
docker exec -u hadoop -it nodemaster ln -s /home/hadoop/etc/hadoop/workers /home/hadoop/spark/conf/slaves
docker exec -u hadoop -it nodemaster chmod +x /home/hadoop/.ssh
docker exec nodemaster chmod 777 /home/hadooop/hive-setting.sh

# setup datanodes
for i in $(seq -w 2 5); do
  mkdir $PWD/tests/node$i
  docker run --rm -dP --network sparknet \
    --name node$i \
    -h node$i \
    -v $PWD/tests/node$i:/home/hadoop/data \
    -v $PWD/config:/home/hadoop/hadoop/etc/hadoop \
    -it res-drl-docker-local.artifactory.swg-devops.com/database-testing/sparkbase
    docker exec -u hadoop -it node$i ln -s /home/hadoop/etc/hadoop/workers /home/hadoop/spark/conf/slaves
    docker exec -u hadoop -it node$i chmod +x /home/hadoop/.ssh
done

docker exec -u hadoop -it nodemaster hadoop/bin/hdfs namenode -format
docker exec -u hadoop -it nodemaster /home/hadoop/hive-setting.sh
docker exec -u hadoop -it nodemaster /home/hadoop/sbin/start-dfs.sh
docker exec -u hadoop -it nodemaster /home/hadoop/sbin/start-yarn.sh

# for x in $(seq -w 2 5); do
#   docker exec -u hadoop -it node$x /home/hadoop/sbin/start-dfs.sh
#   docker exec -u hadoop -it node$x /home/hadoop/sbin/start-yarn.sh
# done
