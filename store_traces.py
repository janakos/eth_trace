import json
import boto3

message = "2"
client = boto3.client('sns')
response = client.publish(
    TargetArn="arn:aws:sns:us-east-2:888292602105:eth_block_topic",
    Message=json.dumps({'default': json.dumps(message)}),
    MessageStructure='string',
    MessageAttributes={'string': {'DataType': 'String'}}
)
