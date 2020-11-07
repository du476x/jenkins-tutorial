#!/bin/bash

# This script mus run as root, and will not destroy your system
# but may lead to innecesary resources spent running jenkins on 
# the background, will make an uninstall eventually

# Also, this assume that you followed the tutorial and everything
# is pre configured, will do my best to make it error prood, but 
# this software IS DELIVERED AS IS WITHOUT ANY WARRANTY

cp ./template/jenkins.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins