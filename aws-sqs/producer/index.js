// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
var fs = require('fs');


var credentials = new AWS.SharedIniFileCredentials({profile: 'default'});
AWS.config.credentials = credentials;

const sqsQueueName = fs.readFileSync(process.env.SQS_QUEUE_URL_LOCATION).toString();

// Set the region 
AWS.config.update({ region: process.env.REGION});

// Create an SQS service object
var sqs = new AWS.SQS({ apiVersion: '2012-11-05' });

var params = {
    MessageAttributes: {
        "Title": {
            DataType: "String",
            StringValue: "The Whistler"
        },
        "Author": {
            DataType: "String",
            StringValue: "John Grisham"
        },
        "WeeksOn": {
            DataType: "Number",
            StringValue: "6"
        }
    },
    MessageBody: "Information about current NY Times fiction bestseller for week of 12/11/2016.",
    MessageDeduplicationId: "TheWhistler!",  // Required for FIFO queues
    MessageGroupId: "Group1!",  // Required for FIFO queues
    QueueUrl: sqsQueueName
};

sqs.sendMessage(params, function (err, data) {
    if (err) {
        console.log("Error", err);
    } else {
        console.log("Success", data.MessageId);
    }
});
