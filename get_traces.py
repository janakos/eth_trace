import boto3
from boto3.dynamodb.conditions import Key
import json
import decimal


class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            return str(o)
        return super(DecimalEncoder, self).default(o)


def handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    ethTraces = dynamodb.Table('EthTraces')

    # List of blocks we want to retreive
    block_traces = {
        i: None
        for i in range(event['startBlock'], event['endBlock'] + 1)
    }
    for block in block_traces.keys():
        filtering_exp = Key('blockNumber').eq(block)
        res = ethTraces.query(KeyConditionExpression=filtering_exp)
        block_traces[int(block)] = res

    print("hellloo")
    print(block_traces)

    return {
        'body': json.dumps(block_traces, cls=DecimalEncoder)
    }