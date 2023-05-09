#!/bin/sh
BEANSTALK_ENV_NAME="$(/opt/elasticbeanstalk/bin/get-config container -k environment_name)"

# systemctl stop amazon-cloudwatch-agent.service