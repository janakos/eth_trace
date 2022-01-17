import json
import boto3


def handler(event, context):
    start = event["startBlock"]
    end = event["endBlock"]
    client = boto3.client('sns')

    print(f"Attempting publish of SNS messages for block: {start} - {end}")
    for i in range(start, end + 1):
        response = client.publish(
            TargetArn="arn:aws:sns:us-east-2:888292602105:eth_block_topic",
            Message=str(i)
        )
    print(f"Published SNS messages")

    return {
        'statusCode': 200,
    }