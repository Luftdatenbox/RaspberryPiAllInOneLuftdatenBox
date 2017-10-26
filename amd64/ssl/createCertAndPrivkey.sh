#!/bin/bash
# source
# http://crohr.me/journal/2014/generate-self-signed-ssl-certificate-without-prompt-noninteractive-mode.html

source sslConfig.sh

# Generate CA key
openssl genrsa -des3 -passout pass:$SelfSignedRootCAPassword -out SelfSignedRootCA.pass.key 2048
# Remove CA key password
openssl rsa -passin pass:$SelfSignedRootCAPassword -in SelfSignedRootCA.pass.key -out SelfSignedRootCA.key
# Generate CA certificate
openssl req -x509 -new -nodes -key SelfSignedRootCA.key -sha256 -days 1024 -out SelfSignedRootCA.crt \
  -subj "/C=DE/ST=Bavaria/L=Bamberg/O=Aperture-Science/OU=Aperture Science Enrichment Center"


# Generate Proxy key
openssl genrsa -des3 -passout pass:$ProxyPassword -out proxy.pass.key 2048
# Remove Proxy key password
openssl rsa -passin pass:$ProxyPassword -in proxy.pass.key -out proxy.key
# Generate signing request
openssl req -new -key proxy.key -out proxy.csr \
  -subj "/C=DE/ST=Bavaria/L=Bamberg/O=Aperture-Science/OU=Aperture Science Enrichment Center/CN=glados.local"
# Sign Proxy request by 
openssl x509 -req -in proxy.csr -CA SelfSignedRootCA.crt -CAkey SelfSignedRootCA.key -CAcreateserial -out proxy.crt -days 1024 -sha256
# clean up
#rm proxy.key
rm proxy.csr


# Generate MQTT key
openssl genrsa -des3 -passout pass:$MQTTPassword -out mqtt.pass.key 2048
# Remove MQTT key password
openssl rsa -passin pass:$MQTTPassword -in mqtt.pass.key -out mqtt.key
# Generate signing request
openssl req -new -key mqtt.key -out mqtt.csr \
  -subj "/C=DE/ST=Bavaria/L=Bamberg/O=Aperture-Science/OU=Aperture Science Enrichment Center/CN=glados.local"
# Sign MQTT request by 
openssl x509 -req -in mqtt.csr -CA SelfSignedRootCA.crt -CAkey SelfSignedRootCA.key -CAcreateserial -out mqtt.crt -days 1024 -sha256
# clean up
#rm mqtt.key
rm mqtt.csr

# remove CA key without password
rm SelfSignedRootCA.key

# copy files to volumes
# CA files
mv SelfSignedRootCA.crt /etc/ca-certificates/selfsignedca/SelfSignedRootCA.crt
mv SelfSignedRootCA.pass.key /etc/ssl/private/selfsignedca/SelfSignedRootCA.pass.key
# Proxy files
mv proxy.crt /etc/ca-certificates/proxy/proxy.crt
mv proxy.key /etc/ssl/private/proxy/proxy.key
# MQTT files
mv mqtt.crt /etc/ca-certificates/mqtt/mqtt.crt
mv mqtt.key /etc/ssl/private/mqtt/mqtt.key
