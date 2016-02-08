#!/bin/bash

# check input arguments
if [ "$#" -ne 2 ]; then
    echo "Please specify pem-key location, cluster name, AWS region!" && exit 1
fi

# get input arguments [aws region, pem-key location]
PEMLOC=$1
INSTANCE_NAME=$2

# check if pem-key location is valid
if [ ! -f $PEMLOC ]; then
    echo "pem-key does not exist!" && exit 1
fi

# import AWS public DNS's
DNS=()
while read line; do
    DNS+=($line)
done < tmp/$INSTANCE_NAME/public_dns

for dns in "${DNS[@]}"
do
    echo $dns
    ssh -o "StrictHostKeyChecking no" -i $PEMLOC ubuntu@$dns '/usr/local/elasticsearch/bin/elasticsearch -d'
done

echo "Elasticsearch started!"

