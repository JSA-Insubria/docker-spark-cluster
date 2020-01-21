#!/bin/bash

#Rimuovo l'immagine hivebase
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi hivebase


#Ricreo l'immagine hivebase (per aggiornare hive)
cd ..
cd hive
./build.sh
cd ..
./cluster.sh deploy
