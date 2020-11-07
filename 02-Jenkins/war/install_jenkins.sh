#!/bin/bash
STABLE=${1:-"no"}
#cp ./binaries/jenkins.* .
CURL=$(which curl)
if [[ $? -eq 1 ]]; then
    echo "curl is missing, make sure curl is installed and accesible from PATH"
    exit 1
fi

JAVA=$(which java)
if [[ $? -eq 1 ]]; then
    echo "java is missing, make sure java is installed and accesible from PATH"
    exit 1
fi
if [[ $STABLE == yes ]]; then
    URL=https://fallback.get.jenkins.io/war-stable/latest/jenkins.war
else
    URL=https://get.jenkins.io/war/latest/jenkins.war
fi
echo "Downloading jenkins"
curl -L -O -C - $URL -s 
curl -L -O -C - $URL.sha256 -s
CHECK=$(sha256sum -c ./jenkins.war.sha256)
if [[ $CHECK =~ "OK" ]]; then
    echo "Sum check, moving files"
    mv jenkins.war  ./binaries/
    rm jenkins.war.sha256
else
    echo "$CHECK"
fi
VERSION=$(java -jar ./binaries/jenkins.war --version)
if [[ ! -d /opt/jenkins/ ]]; then
    echo "Create /opt/jenkins with permissions for your local user"
    exit 1
fi
mkdir -p /opt/jenkins/$VERSION
cp ./binaries/jenkins.war /opt/jenkins/$VERSION
#mv ./binaries/jenkins.war /opt/jenkins/$VERSION
ln -s  /opt/jenkins/$VERSION /opt/jenkins/current

cp -r ssl /opt/jenkins/


