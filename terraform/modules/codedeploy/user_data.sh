#!/usr/bin/env bash

# System update and base packages installation
yum -y update
yum -y install ruby wget curl git mc htop

# CodeDeploy agent installation
mkdir /opt/cdagent
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install -O /opt/cdagent/install
chmod +x /opt/cdagent/install
/opt/cdagent/install auto

# Centos comes with firewalld preinstalled, so make sure web is available from outside
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 3000 -j ACCEPT
