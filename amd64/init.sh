#!/bin/bash

echo "Building grafana-latest-with-plugins"
git clone https://github.com/grafana/grafana.git
docker-compose build Grafana
echo "clean up"
rm -rf grafana

echo "Building LuftdatenBoxStarter"
git clone https://github.com/S3ler/LuftdatenBoxStarter.git
cd LuftdatenBoxStarter
docker-compose build LuftdatenBoxStarter
cd ..

docker-compose up
