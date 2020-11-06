#!/bin/bash
source ./properties/ca_subject.properties
read -s -p "Key Password: " PASSWORD
echo "password is $PASSWORD "
#CA key generation
openssl genrsa -des3 -out $CA_NAME.key -passout pass:$PASSWORD 2048
#CA Root certificate
openssl req -x509 -new -nodes -key $CA_NAME.key -sha256 -days 1825 -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$COMMON_NAME" -passin pass:$PASSWORD -out $CA_NAME.pem
#Add the root certificate to the ca trust this works on Fedora 33 at the moment of writing, check with your distribution for the correct procedure.
if [[ $INSTALL == "true" ]]; then
    sudo cp $CA_NAME.pem /etc/pki/ca-trust/source/anchors/
    sudo update-ca-trust
fi
mv $CA_NAME* ./ca/
