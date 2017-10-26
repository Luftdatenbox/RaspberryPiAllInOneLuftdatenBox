FROM amd64/ubuntu:16.04

COPY ./createCertAndPrivkey.sh /createCertAndPrivkey.sh

RUN apt-get update && apt-get install openssl -y && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/createCertAndPrivkey.sh"]
