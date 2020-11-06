#!/bin/bash
CONFIG=$1
if [[ ! -f ./properties/$CONFIG.properties ]]; then
    echo "File ./properties/$CONFIG.properties not found, painfully dying"
    exit 1
fi
read -s -p "Key Password: " PASSWORD
read -s -p "CA Key Password: " CAPASSWORD
echo "password is $PASSWORD "
source ./properties/$CONFIG.properties
openssl genrsa -out $COMMON_NAME.key -passout pass:$PASSWORD 2048
openssl req -new -key $COMMON_NAME.key -out $COMMON_NAME.csr  -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$COMMON_NAME/emailAddress=$EMAIL"
openssl x509 -req -in $COMMON_NAME.csr -CA ./ca/$CA_KEY.pem -CAkey ./ca/$CA_KEY.key -CAcreateserial -passin pass:$CAPASSWORD \
-out $COMMON_NAME.crt -days 825 -sha256 -extfile ./properties/$CONFIG.ssl.cnf
mkdir -p $CONFIG
mv $COMMON_NAME.csr $COMMON_NAME.crt $COMMON_NAME.key ./$CONFIG

