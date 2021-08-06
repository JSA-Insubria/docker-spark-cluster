#!/bin/bash

NNODE=0

function setNodes {
	NNODE=$([ $# -eq 1 ] && echo "$1" || echo "5")

	echo $NNODE

	rm config/hadoop_config/workers
	rm config/spark_config/slaves
	for i in $(seq -w 2 $NNODE); do
		echo node$i >> config/hadoop_config/workers
		echo node$i >> config/spark_config/slaves
	done
}

# Bring the services up
function startServices {
	docker start nodemaster
	for i in $(seq -w 2 $NNODE); do
		docker start node$i
	done
	sleep 5
	echo ">> Starting hdfs ..."
	docker exec -u hadoop -it nodemaster hadoop/sbin/start-dfs.sh
	sleep 5
	echo ">> Starting yarn ..."
	docker exec -u hadoop -d nodemaster hadoop/sbin/start-yarn.sh
	sleep 5
	echo ">> Starting Spark ..."
	docker exec -u hadoop -d nodemaster /home/hadoop/sparkcmd.sh start
	for i in $(seq -w 2 $NNODE); do
		docker exec -u hadoop -d node$i /home/hadoop/sparkcmd.sh start
	done
	show_info
}

function show_info {
	masterIp=`docker inspect -f "{{ .NetworkSettings.Networks.sparknet.IPAddress }}" nodemaster`
	echo "Hadoop info @ nodemaster: http://$masterIp:8088/cluster"
	echo "Spark info @ nodemaster:  http://$masterIp:8080/"
	echo "DFS Health @ nodemaster:  http://$masterIp:9870/dfshealth.html"
}

if [[ $1 = "start" ]]; then
	startServices
	exit
fi

if [[ $1 = "stop" ]]; then
	docker exec -u hadoop -d nodemaster /home/hadoop/sparkcmd.sh stop
	for i in $(seq -w 2 $NNODE); do
		docker exec -u hadoop -d node$i /home/hadoop/sparkcmd.sh stop
	done
	docker stop nodemaster
	for i in $(seq -w 2 $NNODE); do
		docker stop node$i
	done
	exit
fi

if [[ $1 = "deploy" ]]; then
	docker rm -f `docker ps -a | grep sparkbase | awk '{ print $1 }'` # delete old containers
	docker rm -f `docker ps -a | grep hivebase | awk '{ print $1 }'` # delete old containers
	
	# Deploy Network
	docker network rm sparknet
	docker network create --driver bridge sparknet # create custom network
	
	setNodes
	
	echo ">> Starting nodes master and worker nodes ..."
	# Deploy NodeMaster
	mkdir -p $PWD/tests/nodemaster
	mkdir -p $PWD/results/namenode
	docker run -dP -p 10000:10000 --network sparknet \
		--name nodemaster \
		-h nodemaster \
		-v $PWD/tests/nodemaster:/home/hadoop/data \
		-v $PWD/results:/home/hadoop/results \
		-v $PWD/config/spark_config:/home/hadoop/spark:z \
		-v $PWD/config/hadoop_config:/home/hadoop/hadoop/etc/hadoop:z \
		-v $PWD/config/hive_config:/home/hadoop/hive/conf:z \
		-v $PWD/test-data:/home/hadoop/test-data:z \
		-it hivebase
#		-it res-drl-docker-local.artifactory.swg-devops.com/database-testing/hivebase

	docker exec -it nodemaster chown -R hadoop /home/hadoop/data
	docker exec -it nodemaster chmod -R 777 /home/hadoop/data
	docker exec -it nodemaster chown -R hadoop /home/hadoop/results
	docker exec -it nodemaster chmod -R 777 /home/hadoop/results
	
	# Deploy Nodes
	for i in $(seq -w 2 $NNODE); do
		mkdir -p $PWD/tests/node$i
		mkdir -p $PWD/results/node$i
		docker run -dP --network sparknet \
			--name node$i \
			-h node$i \
			-v $PWD/tests/node$i:/home/hadoop/data \
			-v $PWD/results/node$i:/home/hadoop/results \
			-v $PWD/config/spark_config:/home/hadoop/spark:z \
			-v $PWD/config/hadoop_config:/home/hadoop/hadoop/etc/hadoop:z \
			-it sparkbase
#			-it res-drl-docker-local.artifactory.swg-devops.com/database-testing/sparkbase

		docker exec -it node$i chown -R hadoop /home/hadoop/data
		docker exec -it node$i chmod -R 777 /home/hadoop/data
		docker exec -it node$i chown -R hadoop /home/hadoop/results
		docker exec -it node$i chmod -R 777 /home/hadoop/results
	done
	
	# Format nodemaster
	echo ">> Formatting hdfs ..."
	docker exec -u hadoop -it nodemaster hadoop/bin/hdfs namenode -format
	startServices
	echo ">> Setting Hive ..."
	docker exec nodemaster chmod 777 /home/hadoop/hive-setting.sh
	docker exec -u hadoop -it nodemaster /home/hadoop/hive-setting.sh
	exit
fi

if [[ $1 = "info" ]]; then
	show_info
	exit
fi

echo "Usage: cluster.sh deploy|start|stop"
echo "                 deploy - create a new Docker network"
echo "                 start  - start the existing containers"
echo "                 stop   - stop the running containers" 
echo "                 info   - useful URLs" 
