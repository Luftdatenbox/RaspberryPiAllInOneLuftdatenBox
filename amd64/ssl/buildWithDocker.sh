#!/bin/bash
#1. create volume
docker volume create ssl_certificate
docker volume create ssl_privatekey
#2. create docker s3ler/createcertandprivkey:latest
docker build --tag s3ler/createcertandprivkey:latest --no-cache=true .
docker run -it -v ssl_certificate:/etc/ssl/certs  -v ssl_privatekey:/etc/ssl/private s3ler/createcertandprivkey:latest
#3. run s3ler/createcertandprivkey:latest with volumemounted
