#!/bin/bash

# This script will accept two arguments:
# --profile (string)
# --skip-login (boolean)
printHelp() {
    echo "This script will refresh the SSO token for the given profile name."
    echo "It will open your browser to login to SSO and then print some commands for you to execute in the terminal you want to use AWS CLI with."
    echo ""
    echo "Usage: $0 --profile <profile-name> [options]"
    echo "  -p, --profile <profile-name>: the name of the profile to refresh"
    echo "Optional parameters:"
    echo "  -c, --clear-cache: Delete the files created by the aws sso login command in ~/.aws/sso/cache/"
    echo "  -s, --skip-login: if set, the script will not open your browser to login to SSO. But it will retrieve the credentials from the cache and print them"
    echo "  -h, --help: print this helpfull help"
}

exitIfLsError() {
    lsResult=$?

    if [[ $lsResult == *"ExpiredToken"* ]]; then
        echo "Your token has expired, please login again with the following command :"
        echo "./refresh-sso-token.sh --profile $profile_name"
        exit 1
    elif [[ $lsResult == *"Unable to locate credentials"* ]]; then
        echo "The credentials are not set in your session variables. Reset them with the following command :"
        echo "./refresh-sso-token.sh --profile $profile_name --skip-login"
        exit 1
    elif [[ $lsResult == *"Error"* ]]; then
        echo "Maybe try to re-configure your sso session with the following command :"
        echo "aws configure sso --profile $profile_name"
        exit 1
    # else
    #     echo "Success : you are logged in as $profile_name"
    fi
}

######################
# Get the parameters #
# (exit if errors)   #
######################
skipLogin=false
clearCache=false
while [[ "$#" -gt 0 ]]; do case $1 in
    -p|--profile) profile_name="$2"; shift;;
    -s|--skip-login) skipLogin=true;;
    -c|--clear-cache) clearCache=true;;
    -h|--help) printHelp; exit 0;;
    *) echo "Unknown parameter passed: $1"; printHelp; exit 1;;
esac; shift; done

if [ -z "$profile_name" ]; then
    echo "ERROR: profile name is required" 1>&2
    exit 1
fi

#####################################
# Login to SSO with the web browser #
# (exit if errors)                  #
#####################################
if [ "$skipLogin" = true ]; then
    echo "Skipping login..."
else
    # Clean the SSO cache folder
    if [ "$clearCache" = true ]; then
        rm ~/.aws/sso/cache/*.json
        echo "SSO cache cleared"
    fi

    echo "Logging in with profile name $profile_name"
    echo "Please accept the SSO login prompt in your browser"
    aws configure sso --profile $profile_name
    ssoResult=$?
    if [ $ssoResult -ne 0 ]; then
        echo "ERROR: aws configure sso --profile $profile_name failed with exit code $ssoResult" 1>&2
        exit $ssoResult
    fi
    echo -e "Success : you are logged in as $profile_name\n"
fi

# Clean the CLI cache folder
if [ "$clearCache" = true ]; then
    rm ~/.aws/cli/cache/*.json
    echo "CLI cache cleared"
fi

echo "Running a first request with --profile to get the SSO login URL from the cache config in ~/.aws/cli/cache/"
lsResult=$(aws s3 ls --profile $profile_name 2>&1)
exitIfLsError $lsResult

######################################
# Retreive the values from the cache #
# (exit if errors)                   #
######################################
cliCacheFolder=~/.aws/cli/cache/
cliCacheFile=$(ls -rt $cliCacheFolder | head -n 1) # latest file in the cache folder
cliCacheFile=$cliCacheFolder$cliCacheFile # absolute file path

export AWS_ACCESS_KEY_ID=$(jq ".Credentials.AccessKeyId" $cliCacheFile)
export AWS_SECRET_ACCESS_KEY=$(jq ".Credentials.SecretAccessKey" $cliCacheFile)
export AWS_SESSION_TOKEN=$(jq ".Credentials.SessionToken" $cliCacheFile)

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_SESSION_TOKEN" ]; then
    echo "ERROR: one of the values is empty" 1>&2
    echo "AWS_ACCESS_KEY_ID : $AWS_ACCESS_KEY_ID"
    echo "AWS_SECRET_ACCESS_KEY : $AWS_SECRET_ACCESS_KEY"
    echo "AWS_SESSION_TOKEN : $AWS_SESSION_TOKEN"
    exit 1
fi

echo -e "\nPaste the following lines into the terminal where you want to execute aws commands"
echo "################################################################"
echo "#export PATH='/home/$USER/.ebcli-virtual-env/executables:$PATH\' >> ~/.bash_profile"
echo "source ~/.bash_profile"
echo "export AWS_ACCESS_KEY_ID=$(jq ".Credentials.AccessKeyId" $cliCacheFile)"
echo "export AWS_SECRET_ACCESS_KEY=$(jq ".Credentials.SecretAccessKey" $cliCacheFile)"
echo "export AWS_SESSION_TOKEN=$(jq ".Credentials.SessionToken" $cliCacheFile)"
echo "aws s3 ls"
echo -e "################################################################\n"

# Open a new terminal with access to variables AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN
# bash -c "aws s3 ls --profile $profile_name && \
#     source ~/.bash_profile && \
#     cliCacheFolder=~/.aws/cli/cache/ && \
#     cliCacheFile=$(ls -rt $cliCacheFolder | head -n 1) && \
#     cliCacheFile=$cliCacheFolder$cliCacheFile && \
#     export AWS_ACCESS_KEY_ID=$(jq \".Credentials.AccessKeyId\" $cliCacheFile) && \
#     export AWS_SECRET_ACCESS_KEY=$(jq \".Credentials.SecretAccessKey\" $cliCacheFile) && \
#     export AWS_SESSION_TOKEN=$(jq \".Credentials.SessionToken\" $cliCacheFile) && \
#     aws s3 ls | true && \
#     bash"

# export AWS_ACCESS_KEY_ID=$(jq ".Credentials.AccessKeyId" $cliCacheFile)
# export AWS_SECRET_ACCESS_KEY=$(jq ".Credentials.SecretAccessKey" $cliCacheFile)
# export AWS_SESSION_TOKEN=$(jq ".Credentials.SessionToken" $cliCacheFile)
# echo "Testing the credentials with the following command : aws s3 ls" 
# lsResult=$(aws s3 ls 2>&1) # Test if you can access S3 without profile-name
# exitIfLsError $lsResult
# echo "SUCCESS: You can now execute aws commands without the --profile parameter"
# echo "AWS_ACCESS_KEY_ID : $AWS_ACCESS_KEY_ID"
# echo "AWS_SECRET_ACCESS_KEY : $AWS_SECRET_ACCESS_KEY"
# echo "AWS_SESSION_TOKEN : $AWS_SESSION_TOKEN"

exit 0