# Adjust accordingly, I'm using a local nexus for build speed and it's on the section 03 of the tutorial
FROM jenkins/jenkins:2.249.3-lts-alpine
# Local nexus Cache
#FROM nexus.workstation.mx:55500/jenkins/jenkins:2.249.3-lts-alpine 
# Cert and key should be readable by others for this to work
COPY ./ssl/jenkins.workstation.mx.crt /var/lib/jenkins/ssl/jenkins.workstation.mx.crt
COPY ./ssl/jenkins.workstation.mx.key /var/lib/jenkins/ssl/jenkins.workstation.mx.key 
COPY ./ssl/root_ca.pem /var/lib/jenkins/ssl/root_ca.pem
USER root
RUN apk add --no-cache ca-certificates && \
    mkdir /usr/share/ca-certificates/extra && \
    mv /var/lib/jenkins/ssl/root_ca.pem  /usr/share/ca-certificates/extra/ && \
    update-ca-certificates

USER jenkins
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8443 --httpsCertificate=/var/lib/jenkins/ssl/jenkins.workstation.mx.crt --httpsPrivateKey=/var/lib/jenkins/ssl/jenkins.workstation.mx.key
EXPOSE 8443
