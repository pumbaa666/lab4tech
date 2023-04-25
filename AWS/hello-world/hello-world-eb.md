Deploy an *EC2 instance* running a NodeJS Hello-World with *Elasticbeanstalk* and *S3 Bucket*
===

Creating Accounts
---

**Create an *AWS Root Account*** in the desired Region.
Ireland (*eu-west-1*) is better because it has the most services enabled.

**Create an *Organisation*** ([Doc 1](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html?org_product_rc_usergude=), [Doc 2](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_org_create.html))
Login as Root User and go to the [AWS Administration Console](https://us-east-1.console.aws.amazon.com/organizations/v2/home/accounts)
Create the organisation (TODO check / screenshot)
From [the CLI](https://docs.aws.amazon.com/cli/latest/reference/organizations/create-organization.html?orgs_product_rc_CLI) (TODO)

**Create an *Administrator User Account***

Login to the [IAM Identity Center](https://eu-west-1.console.aws.amazon.com/singlesignon/identity/home?region=eu-west-1#) (and **not** just *IAM* )

Create an *Admin Group*.
![Create an Admin Group 1](screenshots/02-group-1.png)
![Create an Admin Group 2](screenshots/02-group-2.png)

Create a *User*, add it to the *Admin group*.
![Create a User 1](screenshots/03-user-1.png)
![Create a User 2](screenshots/03-user-2.png)
![Add user to the Group](screenshots/03-user-3.png)

Create a *Predefined Permission set* with **AdministratorAccess**.
![Create a Permission set 1](screenshots/04-permission-1.png)
![Create a Permission set 2](screenshots/04-permission-2.png)
![Enable Permission set](screenshots/04-permission-3.png)

Set the *Permission set* to the *Admin Group*.
![Set the permission to the group 1](screenshots/05-assign-group-1.png)
![Set the permission to the group 2](screenshots/05-assign-group-2.png)

Install AWS CLI v2
---
[Doc](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
```
sudo apt install unzip
pushd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
popd

# Add eb commands (Elasticbeanstalk) to the PATH
echo 'export PATH="/home/$USER/.ebcli-virtual-env/executables:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
```


Configuring SSO (Single Sign On)
---

**Configure your session by login in**
Login to the [IAM Identity Center](https://eu-west-1.console.aws.amazon.com/singlesignon/identity/home?region=eu-west-1#) with your **Root Account**, go to *Settings*, tab *Identity Source* and note the **AWS access portal URL**, it's your *SSO start URL*.
![Note the AWS access portal URL](screenshots/01-sso-start-url.png)

Logout from this account.

```
aws configure sso
    # Chose whatever you want
    SSO session name : admin-session
    
    # Given in the Settings of the IAM Identity Center
    SSO start URL : https://d-9367506e20.awsapps.com/start
    
    # Your default region 
    region : eu-west-1
    
    # Let the default
    SSO registration scopes : sso:account:access
```

When the browser starts login with your **User Account** (not the Root account, here *user-account*) and accept the permissions.

the config will be saved in your home
```
cat ~/.aws/config
    [profile user-account]
    sso_session = admin-session
    sso_account_id = 385324514552
    sso_role_name = AdministratorAccess
    region = eu-west-1
    [sso-session admin-session]
    sso_start_url = https://d-9367506e20.awsapps.com/start
    sso_region = eu-west-1
    sso_registration_scopes = sso:account:access
```

the CLI and SSO session are cached in the same folder
```
ls -lh ~/.aws/*
    /home/user/.aws/cli:
    drwxrwxr-x 2 user user 4.0K Apr 24 16:54 cache

    /home/user/.aws/sso:
    drwxrwxr-x 2 user user 4.0K Apr 24 13:57 cache
```

To use this profile, specify the profile name using --profile with every command.

i.e :
```
aws s3 ls --profile user-account
aws s3 rm s3://elasticbeanstalk-eu-west-1-385324514552/ --profile user-account
```

Alternatively you can set some **environment variables** (env. var.) to get rid of the *--profile* parameter.

```
cliCacheFolder=~/.aws/cli/cache/ # aws default cache folder
cliCacheFile=$(ls -rt $cliCacheFolder | head -n 1) # CLI config file name
cliCacheFile=$cliCacheFolder$cliCacheFile # absolute file path
echo "export AWS_ACCESS_KEY_ID=$(jq ".Credentials.AccessKeyId" $cliCacheFile)"
echo "export AWS_SECRET_ACCESS_KEY=$(jq ".Credentials.SecretAccessKey" $cliCacheFile)"
echo "export AWS_SESSION_TOKEN=$(jq ".Credentials.SessionToken" $cliCacheFile)"
```
run this code and copy/past the result in the terminal you want to use the CLI commands from.

Create a Nodejs hello-world
---
```
mkdir aws-hello-world-node && cd $_
vi package.json
    {
        "name": "aws-hello-world",
        "version": "1.0.0",
        "main": "src/app.js",
        "scripts": {
            "start": "node src/app.js"
        },
        "dependencies": {
            "http": "^0.0.1-security"
        }
    }

vi src/app.js
    require('http').createServer((request, response) => {
        response.writeHead(200, {
            'Content-Type': 'text/plain'
        });
        response.write("It works!");
        response.end();
    }).listen(1337);
    console.log("Webserver started on http://localhost:1337");
```

Deploying the app
---

Create new env from local src code
```
cd aws-hello-world-node

eb init
    # 4 (Region Ireland)

# https://stackoverflow.com/questions/64363112/codecommit-fails-when-after-commit-rewrite-with-amend
eb codesource local

eb create # If it fails due to ACL restriction, enable ACL (see next section)
    TODO

eb ssh
```

**Enable *ACL*** ([stackoverflow](https://stackoverflow.com/questions/70333681/for-an-amazon-s3-bucket-deployment-from-github-how-do-i-fix-the-error-accesscont))
Login to [AWS S3 Bucket](https://s3.console.aws.amazon.com/s3/buckets?region=eu-west-1#)
Select the S3 bucket created with *eb create*, tab *Permission*, box *Object Ownership* and enable *ACL*.
![Select the new Bucket](screenshots/10-enable-acl-1.png)
![Go to Permission tab](screenshots/10-enable-acl-2.png)
![Edit Object Ownership](screenshots/10-enable-acl-3.png)
![Enable ACL](screenshots/10-enable-acl-4.png)


**Terminate and delete elasticbeanstalk environment and application**
```
aws elasticbeanstalk terminate-environment --environment-name helloworld-node-app-dev
aws elasticbeanstalk delete-application --application-name helloworld-node-app
```

