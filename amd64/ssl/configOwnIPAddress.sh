#!/bin/bash

IPAddress=""

# get own IPAddress
ownIPAddresses=$(hostname --all-ip-addresses)
for ownIPAddress in $ownIPAddresses
do
    # filter out IPAddresses starting with 127.* - used either for loopback or docker networks
    if [[ "$ownIPAddress" != "127." ]]
    then
        IPAddress=$ownIPAddress
        break
    fi
done


# If a IPAddress or a CN entry in the sslConfig.sh already exist then we do not use our own IPAddress
existingIPAddress=$(cat sslConfig.sh | grep IPAddress)
existingCN=$(cat sslConfig.sh | grep IPAddress)
if [ -n "$existingIPAddress" ]
then
    echo "IPAddress entry in sslConfig.sh already exists."
    exit
fi
if [ -n "$existingCN" ]
then
    echo "CN entry in sslConfig.sh already exists."
    exit
fi

# check if IPAddress was found - tell if not
# A empty IPAddress entry in the sslConfig.sh file will result in not creating a certificate.
if [ -z "$IPAddress" ]
then
    echo "Could not find own IPAddress starting without \"127.\""
    echo "IPAddress=\"\"" >> sslConfig.sh
fi

echo "Own IPAddress used for Self-Signed SSL Certificates: $IPAddress"
echo "IPAddress=\"${IPAddress}\"" >> sslConfig.sh
