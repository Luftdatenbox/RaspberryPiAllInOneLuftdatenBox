#!/bin/bash
# this bash script removes all volumes from the docker-compose file and all using containers
removeCMD="docker-compose down --volumes"
removeOutput=""
while true
do
    removeOutput=$(docker-compose down --volumes | grep "ERROR")
    if [ -z "$removeOutput" ]
    then
        exit
    fi
    usingContainerID=$(echo $removeOutput | | awk -F'[][]' '{print $2}')
    docker rm $usingContainerID
done
