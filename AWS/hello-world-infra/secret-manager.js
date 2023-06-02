// https://eu-west-1.console.aws.amazon.com/secretsmanager/newsecret?region=eu-west-1
// https://youtu.be/DjvlhrBRtXM?t=149


// Use this code snippet in your app.
// If you need more information about configurations or implementing the sample
// code, visit the AWS docs:
// https://docs.aws.amazon.com/sdk-for-node-js/v2/developer-guide/getting-started-nodejs.html

// Make sure to install the following packages in your code
// npm install aws-sdk

const AWS = require('aws-sdk');
const region = "eu-west-1";
const SECRET_NAME = "dev/testing";

// Create your secret with one of the following commands in a CLI:
// aws secretsmanager create-secret --name dev/testing --secret-string "super-secret!"
// aws secretsmanager create-secret --name dev/testing --secret-string file://secret.json # create the file `secret.json` first
// https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/create-secret.html

// Create a Secrets Manager client
const client = new AWS.SecretsManager({
    region: region
});

async function getSecret(secretName) {
    const request = {
        SecretId: secretName
    };

    try {
        const data = await client.getSecretValue(request).promise();
        const secretValue = data.SecretString;
        console.log("DEBUG secret : " + secretValue);
        return secretValue;
    } catch (e) {
        console.log("error : " + e);
        return null;
    }
}

// Get secret asynchronously
getSecret(SECRET_NAME).then((secretValue) => {
    console.log("secret : " + secretValue);
    // Your code goes here.
    
}).catch((err) => {
    console.log("error : " + err);
});
