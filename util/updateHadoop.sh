#!/bin/bash

#Rimuovo l'immagine hivebase
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi sparkbase hivebase


#Ricreo l'immagine hivebase (per aggiornare hive)
cd ..
cd spark
./build.sh
cd ..
cd hive
./build.sh
cd ..
./cluster.sh deploy
