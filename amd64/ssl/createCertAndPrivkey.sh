#!/bin/bash
# source
# http://crohr.me/journal/2014/generate-self-signed-ssl-certificate-without-prompt-noninteractive-mode.html

source sslConfig.sh

# check Configuration
if [ -z "$IPAddress" ] && [ -z "CN" ]
then
    echo "cannot create Self-Signed SSL Certificates IPAddress or CN"
    exit
fi

if [ -n "$IPAddress" ]
then
    CN=$IPAddress
fi

if [ -z "$SelfSignedRootCAPassword" ]
then
    echo "cannot create Self-Signed SSL Certificates without SelfSignedRootCAPassword"
    exit
fi

if [ -z "$ProxyPassword" ]
then
    ProxyPassword="x"
fi

if [ -z "$MQTTPassword" ]
then
    MQTTPassword="x"
fi

if [ -z "$C" ]
then
    C="DE"
fi

if [ -z "$ST" ]
then
    ST="Berlin"
fi

if [ -z "$L" ]
then
    L="Berlin"
fi

if [ -z "$O" ]
then
    O="Aperture-Science"
fi

if [ -z "$OU" ]
then
    OU="Aperture Science Enrichment Center"
fi

if [ -z "$OU" ]
then
    OU="Aperture Science Enrichment Center"
fi

if [ -z "$CN" ]
then
    CN="glados.local"
fi

# print Configuration
echo "Using following Configuration:"
echo "C: $C"
echo "ST: $ST"
echo "L: $L"
echo "O: $O"
echo "OU: $OU"
echo "CN: $CN"


# Generate CA key
openssl genrsa -des3 -passout pass:$SelfSignedRootCAPassword -out SelfSignedRootCA.pass.key 2048
# Remove CA key password
openssl rsa -passin pass:$SelfSignedRootCAPassword -in SelfSignedRootCA.pass.key -out SelfSignedRootCA.key
# Generate CA certificate
openssl req -x509 -new -nodes -key SelfSignedRootCA.key -sha256 -days 1024 -out SelfSignedRootCA.crt \
  -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU"

# Generate Proxy key
openssl genrsa -des3 -passout pass:$ProxyPassword -out proxy.pass.key 2048
# Remove Proxy key password
openssl rsa -passin pass:$ProxyPassword -in proxy.pass.key -out proxy.key
# Generate signing request
openssl req -new -key proxy.key -out proxy.csr \
  -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN"
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
  -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN"
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
