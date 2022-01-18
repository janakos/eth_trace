import boto3
from boto3.dynamodb.conditions import Key
import json
import decimal


# Encodes decimals to avoid json parsing error
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            return str(o)
        return super(DecimalEncoder, self).default(o)


def handler(event, context):

    # Connect to dynamo
    dynamodb = boto3.resource('dynamodb')
    ethTraces = dynamodb.Table('EthTraces')

    # Load user desired block range
    timeline = json.loads(event['body'])
    start = timeline['startBlock']
    end = timeline['endBlock']

    # Create results dict
    block_traces = {
        i: None
        for i in range(start, end + 1)
    }

    # Query all items per block
    for block in block_traces.keys():
        filtering_exp = Key('blockNumber').eq(block)
        resp = ethTraces.query(KeyConditionExpression=filtering_exp)
        block_traces[block] = resp['Items']

    return {
        'body': json.dumps([block_traces], cls=DecimalEncoder)
    }
