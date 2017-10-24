#!/bin/bash
# source
# http://crohr.me/journal/2014/generate-self-signed-ssl-certificate-without-prompt-noninteractive-mode.html

# TODO generate the certs only if the files does NOT exist (dont overwrite existing certs)
# Step 1: Generate a Private Key
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
## Step 3: Remove Passphrase from Key
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key
# Step 2: Generate a CSR (Certificate Signing Request)
# TODO: if certificate.conf does not exist use the snakeoil stuff
# TODO: theoratically look for each openssl req key value if it isnt empty and create string
openssl req -new -key server.key -out server.csr \
  -subj "/C=DE/ST=Bavaria/L=Bamberg/O=Aperture-Science/OU=Aperture Science Enrichment Center/CN=glados.local"
# Step 4: Generating a Self-Signed Certificate
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
ls -l
# Step 5: move certificates
mv server.crt /etc/ssl/certs/server.crt
mv server.key /etc/ssl/private/server.key
mv server.csr /etc/ssl/csr/server.csr
#TODO set correct access rights for cert, key and csr
# SSLCertificateFile (Certificate/PublicKey) server.crt (aka fullchain.pem)
# SSLCertificateKeyFile (Private Key) server.key (aka privkey.pem)
# SSLCertificatAuthorityFile (CA) server.csr (aka ca.csr)


