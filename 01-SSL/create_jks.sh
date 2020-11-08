#!/bin/bash
CONFIG=$1
if [[ ! -f ./properties/$CONFIG.properties ]]; then
    echo "File ./properties/$CONFIG.properties not found, painfully dying"
    exit 1
fi
source ./properties/$CONFIG.properties
read -s -p "Key Password: " KEYPASSWORD
if [[ -f $CONFIG/$COMMON_NAME.p12 ]]; then
    rm $CONFIG/$COMMON_NAME.p12 
fi
if [[ -f $CONFIG/$COMMON_NAME.jks ]]; then
    rm $CONFIG/$COMMON_NAME.jks
fi
openssl pkcs12 -export -in ./$CONFIG/$COMMON_NAME.crt -inkey ./$CONFIG/$COMMON_NAME.key -passin pass:$KEYPASSWORD -passout pass:$KEYPASSWORD -out $COMMON_NAME.p12 -name "$COMMON_NAME"
read -s -p "JKS Password: " PASSWORD
keytool -importkeystore -storepass $PASSWORD -srcstorepass $KEYPASSWORD -destkeystore $COMMON_NAME.jks -srckeystore $COMMON_NAME.p12 -srcstoretype pkcs12 -alias "$COMMON_NAME"
mv $COMMON_NAME.p12 $COMMON_NAME.jks $CONFIG
