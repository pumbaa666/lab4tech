# Some usefull AWS / EB commands

# Query JMESPath documentation
# https://jmespath.org/tutorial.html


# EB
eb init
eb create
eb deploy
eb deploy --stage # Deploy without having to commit. Useful for testing and developing purposes.
eb health
eb logs --all
eb ssh
eb terminate

eb printenv
#  Environment Variables:
#      NODEJS_PORT = 1337
eb status -v

# SSO Admin
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sso-admin/index.html#available-commands
aws sso-admin list-instances

# Security Groups
aws ec2 describe-security-groups --query SecurityGroups[*].[GroupName,GroupId,Description,VpcId]
MY_SECURITY_GROUP_ID="sg-0c3cd60f593cf3ef2"
aws ec2 delete-security-group --group-id $MY_SECURITY_GROUP_ID

# ElasticBeanstalk
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elasticbeanstalk/index.html#available-commands
aws elasticbeanstalk describe-environments --query Environments[*].[EnvironmentName,EnvironmentId,Status]
MY_ENVIRONMENT_NAME="my-new-env"
aws elasticbeanstalk terminate-environment --environment-name $MY_ENVIRONMENT_NAME
aws elasticbeanstalk describe-environments --environment-names $MY_ENVIRONMENT_NAME --query Environments[*].[EnvironmentName,EnvironmentId,Status]
MY_APP_NAME="hello-world-app"
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
# Open a port
EB_MAC_ADRESS=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
EB_SG_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$EB_MAC_ADRESS/security-group-ids/)
PROTOCOL="tcp"
CIDR="0.0.0.0/0"
aws ec2 authorize-security-group-ingress --group-id $EB_SG_ID --port 8080 --protocol $PROTOCOL --cidr $CIDR
aws ec2 describe-security-groups --group-ids $EB_SG_ID --output text --filter Name=ip-permission.to-port,Values=8080

# CodeCommit Repository
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codecommit/index.html#cli-aws-codecommit
MY_REPOSITORY_NAME="hello-world-repo"
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


https://youtu.be/RrKRN9zRBWs?t=4140
# On the EB machine
curl -s http://169.254.169.254/latest/meta-data/
curl -s http://169.254.169.254/latest/meta-data/mac/
curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/
curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/02:56:36:71:c6:17/security-group-ids/
curl -s http://169.254.169.254/latest/meta-data/public-ipv4

# Lambda
# https://www.youtube.com/watch?v=dreJIfZMEUM 
aws lambda invoke --function-name hello-lambda --payload ewogICJrZXkxIjogInZhbHVlMSIsCiAgImtleTIiOiAidmFsdWUyIiwKICAia2V5MyI6ICJ2YWx1ZTMiCn0= response.json # Response in response.json
aws lambda invoke --function-name hello-lambda --invocation-type Event --payload ewogICJrZXkxIjogInZhbHVlMSIsCiAgImtleTIiOiAidmFsdWUyIiwKICAia2V5MyI6ICJ2YWx1ZTMiCn0= response.json # Event --> asyncronous. response.json is empty

# SQS
# https://www.youtube.com/watch?v=ChMjrubsTLY&t=475
aws sqs list-queues
    # "QueueUrls": ["https://sqs.eu-west-1.amazonaws.com/385324514552/hello-queue"]
        
aws sqs send-message --queue-url https://sqs.eu-west-1.amazonaws.com/385324514552/hello-queue --message-body coucou-2-from-cli --delay-seconds 10
aws sqs receive-message --queue-url https://sqs.eu-west-1.amazonaws.com/385324514552/hello-queue --wait-time-seconds 0 # 0 sec --> short polling
# long polling --> wait-time-seconds 20
aws sqs receive-message --queue-url https://sqs.eu-west-1.amazonaws.com/385324514552/hello-queue --wait-time-seconds 20

# Secrets Manager
# https://www.youtube.com/watch?v=ChMjrubsTLY&t=475
aws secretsmanager create-secret --name hello-secret --secret-string "coucou"
aws secretsmanager get-secret-value --secret-id hello-secret
aws secretsmanager delete-secret --secret-id hello-secret
aws secretsmanager list-secrets

# SNS
TOPIC_ARN=$(aws sns create-topic --name MySuperTopic --query TopicArn | tr -d '"') && echo $TOPIC_ARN
# "TopicArn": "arn:aws:sns:eu-west-1:385324514552:MySuperTopic"
aws sns publish --topic-arn $TOPIC_ARN --message "Hello World"
aws sns subscribe --topic-arn $TOPIC_ARN --protocol http