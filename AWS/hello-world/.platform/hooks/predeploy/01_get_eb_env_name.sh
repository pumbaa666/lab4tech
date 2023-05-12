#!/bin/sh
BEANSTALK_ENV_NAME="$(/opt/elasticbeanstalk/bin/get-config container -k environment_name)"
echo "Beanstalk environment name : $BEANSTALK_ENV_NAME"