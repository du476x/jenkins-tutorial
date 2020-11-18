#!/bin/bash
CONFIG=$1
if [[ ! -f ./properties/$CONFIG.properties ]]; then
    echo "File ./properties/$CONFIG.properties not found, painfully dying"
    exit 1
fi
read -s -p "Key Password: " PASSWORD
read -s -p "CA Key Password: " CAPASSWORD
source ./properties/$CONFIG.properties
openssl genrsa -out $COMMON_NAME.key -passout pass:$PASSWORD 2048
openssl rsa -in ./$COMMON_NAME.key -passin pass:$PASSWORD -out ./$COMMON_NAME.passless.key 
openssl req -new -key $COMMON_NAME.key -out $COMMON_NAME.csr  -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$COMMON_NAME/emailAddress=$EMAIL"
echo "----------------------------"
echo "-------CSR CONTENT----------"
echo "----------------------------"
echo ""
cat $COMMON_NAME.csr
openssl x509 -req -in $COMMON_NAME.csr -CA ./ca/$CA_KEY.pem -CAkey ./ca/$CA_KEY.key -CAcreateserial -passin pass:$CAPASSWORD \
-out $COMMON_NAME.crt -days 825 -sha256 -extfile ./properties/$CONFIG.ssl.cnf
echo "----------------------------"
echo "-------CRT CONTENT----------"
echo "----------------------------"
echo ""
cat $COMMON_NAME.crt
mkdir -p $CONFIG
mv $COMMON_NAME.csr $COMMON_NAME.crt $COMMON_NAME.*key ./$CONFIG
cat ./$CONFIG/$COMMON_NAME.passless.key ./$CONFIG/$COMMON_NAME.crt > ./$CONFIG/$COMMON_NAME.bundle.crt
openssl verify -verbose -CAfile  ./ca/$CA_KEY.pem ./$CONFIG/$COMMON_NAME.crt
