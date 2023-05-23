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

const secretName = "dev/test";

// Create a Secrets Manager client
const client = new AWS.SecretsManager({
    region: region
});

const getSecret = async () => {
    const request = {
        SecretId: secretName
    };

    try {
        const data = await client.getSecretValue(request).promise();
        const secret = data.SecretString;
        // Your code goes here.
    } catch (e) {
        //For a list of exceptions thrown, see
        //https://docs.aws.amazon.com/secretsmanager/latest/apire