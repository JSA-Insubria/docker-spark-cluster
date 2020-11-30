#!/bin/bash

# Generate data
cd test-data/dataset
sh ./generate_data.sh 1
cd ..
cd ..

# creo le tabelle e carico i dati generati
docker exec -it -u hadoop nodemaster /home/hadoop/hive/bin/hive -f /home/hadoop/test-data/createtable_loaddata.hql

# genero i dati dei file e del cluster
docker exec -it -u hadoop nodemaster /home/hadoop/hadoop/bin/hdfs balancer -filesInfo
docker exec -it -u hadoop nodemaster /home/hadoop/hadoop/bin/hdfs balancer -clusterInfo

#eseguo le query
for j in {1..1}; do #22
	for i in {1..1}; do #5
	docker exec -it -u hadoop nodemaster /home/hadoop/hive/bin/hive -f /home/hadoop/test-data/query/query-"$j".hql;
	done
done

# copio i dati del test in original, eseguo l'algoritmo per 1m e sposto l'ultimo dei risulstati
cd algorithm
sh ./move_data.sh original
sh ./run_algorithm.sh original 1h
cd ..

# Sposto i blocchi tra i nodi
docker exec -it -u hadoop nodemaster /home/hadoop/hadoop/bin/hdfs balancer -moveFile



# ------------------------------------------



# genero i dati dei file e del cluster
docker exec -it -u hadoop nodemaster /home/hadoop/hadoop/bin/hdfs balancer -filesInfo
docker exec -it -u hadoop nodemaster /home/hadoop/hadoop/bin/hdfs balancer -clusterInfo

#eseguo le query
for j in {1..1}; do #22
	for i in {1..1}; do #5
	docker exec -it -u hadoop nodemaster /home/hadoop/hive/bin/hive -f /home/hadoop/test-data/query/query-"$j".hql;
	done
done

# Sposto i dati nuovi
cd algorithm
sh ./move_data.sh last
cd ..

# Benchmark
cd algorithm
sh ./run_benchmark.sh original
sh ./run_benchmark.sh last
cd ..
