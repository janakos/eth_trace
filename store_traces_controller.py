import json
import requests
import boto3


def handler(event, context):

    with requests.Session() as s:
        block_number = int(event['Records'][0]['Sns']['Message'])
        r = s.post(
            'https://eth-trace.gateway.pokt.network/v1/lb/61d91215fa95d4003afff1fd',
            auth=('', 'b47d07bcc4754254f1cb7a30b2144f36'),
            json={
                "jsonrpc": "2.0",
                "method": "trace_block",
                "params": [hex(block_number)],
                "id": 1
            }
        )
        response = r.json()

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('EthTraces')

    print(f'Loading traces to DynamoDB from block: {block_number}')
    with table.batch_writer() as writer:
        for idx, i in enumerate(response["result"]):
            writer.put_item(Item={
                "traceHash": f'{idx}_{i.get("transactionHash", idx)}_{i["blockHash"]}',
                "blockNumber": i["blockNumber"],
                "trace": str(i)
            })

    return {
        'statusCode': 200,
        'blockNumber': block_number,
        'traces_inserted': len(response["result"])
    }