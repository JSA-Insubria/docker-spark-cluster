#!/bin/bash

firstNode=2
lastNode=19

# Bring the services up
function startServices {
	docker start nodemaster
	for (( i=$firstNode; i<=$lastNode; i++ )) do
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
	for (( i=$firstNode; i<=$lastNode; i++ )) do
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
	for (( i=$firstNode; i<=$lastNode; i++ )) do
		docker exec -u hadoop -d node$i /home/hadoop/sparkcmd.sh stop
	done
	docker stop nodemaster
	for (( i=$firstNode; i<=$lastNode; i++ )) do
		docker stop node$i
	done
	exit
fi

if [[ $1 = "deploy" ]]; then
	docker rm -f `docker ps -a | grep sparkbase | awk '{ print $1 }'` # delete old containers
	docker rm -f `docker ps -a | grep hivebase | awk '{ print $1 }'` # delete old containers
	docker network rm sparknet
	docker network create --driver bridge sparknet # create custom network

	echo ">> Starting nodes master and worker nodes ..."
	docker run -dP -p 10000:10000 --network sparknet --name nodemaster -h nodemaster -it hivebase
	for (( i=$firstNode; i<=$lastNode; i++ )) do
		docker run -dP --network sparknet --name node$i -it -h node$i sparkbase
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
