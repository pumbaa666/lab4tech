#!/bin/bash

# Query JMESPath documentation
# https://jmespath.org/tutorial.html



# Security Groups
aws ec2 describe-security-groups --query SecurityGroups[*].[GroupName,GroupId,Description,VpcId]
MY_SECURITY_GROUP_ID="sg-0c3cd60f593cf3ef2"
aws ec2 delete-security-group --group-id $MY_SECURITY_GROUP_ID

# ElasticBeanstalk
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elasticbeanstalk/index.html#available-commands
aws elasticbeanstalk describe-environments --query Environments[*].[EnvironmentName,EnvironmentId,Status]
MY_ENVIRONMENT_NAME="my-new-env"
MY_ENVIRONMENT_NAME="re-hello-world-dev"
aws elasticbeanstalk terminate-environment --environment-name $MY_ENVIRONMENT_NAME
aws elasticbeanstalk describe-environments --environment-names $MY_ENVIRONMENT_NAME --query Environments[*].[EnvironmentName,EnvironmentId,Status]
MY_APP_NAME="hello-world-app-2"
MY_APP_NAME="helloworld-node-app"
aws elasticbeanstalk delete-application --application-name $MY_APP_NAME
aws elasticbeanstalk describe-applications --application-name $MY_APP_NAME
aws elasticbeanstalk describe-application-versions --application-name $MY_APP_NAME --query ApplicationVersions[*].[ApplicationName,VersionLabel,Status,SourceBundle.S3Bucket]

# EC2
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/index.html#available-commands
MY_INSTANCE_ID="i-08de3c977fc6bfab1"
aws ec2 describe-instances --query Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name] # List all instances
aws ec2 describe-instances --instance-ids $MY_INSTANCE_ID --query Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]
aws ec2 stop-instances --instance-ids $MY_INSTANCE_ID --query TerminatingInstances[*].CurrentState.Name
aws ec2 describe-instances --instance-ids $MY_INSTANCE_ID --query Reservations[*].Instances[*].[State.Name,StateTransitionReason,SubnetId,NetworkInterfaces[*].PrivateIpAddress,SecurityGroups[*].GroupId]
aws ec2 terminate-instances --instance-ids $MY_INSTANCE_ID --query TerminatingInstances[*].CurrentState.Name
aws ec2 describe-instances --instance-ids $MY_INSTANCE_ID --query Reservations[*].Instances[*].[State.Name,StateTransitionReason,SubnetId,NetworkInterfaces[*].PrivateIpAddress,SecurityGroups[*].GroupId]

# CodeCommit Repository
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codecommit/index.html#cli-aws-codecommit
MY_REPOSITORY_NAME="re-hello-world-repo"
aws codecommit get-repository --repository-name $MY_REPOSITORY_NAME
aws codecommit delete-repository --repository-name $MY_REPOSITORY_NAME

# S3 Buckets
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/index.html#available-commands
aws s3 ls
MY_BUCKET_NAME="elasticbeanstalk-eu-west-1-385324514552"
MY_BUCKET_APP="helloworld-node-app"
aws s3 ls $MY_BUCKET_NAME
aws s3 ls s3://$MY_BUCKET_NAME
aws s3 ls s3://$MY_BUCKET_NAME/$MY_BUCKET_APP/
aws s3 rm s3://$MY_BUCKET_NAME --recursive
aws s3 rm s3://$MY_BUCKET_NAME/$MY_BUCKET_APP/

# Load Balancer
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/index.html#available-commands
MY_LOAD_BALANCER_NAME="awseb-e-r-AWSEBLoa-I80CWFYZWSF2"
aws elbv2 describe-load-balancers --names $MY_LOAD_BALANCER_NAME




# SSO Admin
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sso-admin/index.html#available-commands
aws sso-admin list-instances
