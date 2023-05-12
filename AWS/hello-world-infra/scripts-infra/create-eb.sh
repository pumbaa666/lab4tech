#!/bin/bash

# This script creates an Elastic Beanstalk environment with the following parameters:
KEYNAME=aws-eb # Set the keyname created with `eb init`. They are usually stored in ~/.ssh/
REGION=eu-west-1 # Ireland

INSTANCE_TYPE=t3.micro # Free tiers instance
PLATFORM=node.js-18
MIN_INSTANCES=1
MAX_INSTANCES=2
ELB_TYPE=network # Valid values: classic, application, network
CNAME=hello-world

# Test if the folder .elasticbeanstalk exists
if [ ! -d .elasticbeanstalk ]; then
    echo "Your are not in a EB environment (the folder .elasticbeanstalk does not exist). Cd into it or run 'eb init' first."
    exit 1
fi

# Create the environment
echo "Creating the environment with the following parameters : "
echo "Instance type: $INSTANCE_TYPE"
echo "Platform: $PLATFORM"
echo "Region: $REGION, CNAME: $CNAME"
echo "Load Balancer Type: $ELB_TYPE"
echo "Min instances: $MIN_INSTANCES, Max instances: $MAX_INSTANCES"
echo "SSH Keyname: $KEYNAME"

eb create dev-env --branch_default \
    --instance_type t3.micro --platform node.js-18 \
    --min-instances 1 --max-instances 2 \
    --region eu-west-1 \
    --elb-type network \
    --cname hello-world \
    --keyname $KEYNAME
    
    # --instance_profile pumbaa-admin \
    # --version test-0.0.1 \
    # --envvars .ebextensions/environment.config
    # --min-instances 1 --max-instances 2 \
    # --single \
    # --shared-lb-port 1337 \
    # --tags environment=test \
    
if [ $? -ne 0 ]; then
    echo "An error occured while creating the environment : \n$?"
    exit 1
else
    echo "Deploying..."
    eb deploy dev-env
fi
    
exit 0