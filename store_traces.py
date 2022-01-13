import json
import requests
import boto3


def handler(event, context):

    with requests.Session() as s:
        r = s.post(
            'https://eth-trace.gateway.pokt.network/v1/lb/61d91215fa95d4003afff1fd',
            auth=('', 'b47d07bcc4754254f1cb7a30b2144f36'),
            json={
                "jsonrpc": "2.0",
                "method": "trace_block",
                "params": [hex(12914945)],
                "id": 1
            }
        )
        response = r.json()

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('EthTraces')

    with table.batch_writer() as writer:
        for idx, i in enumerate(response["result"]):
            writer.put_item(Item={
                "traceHash": f'{idx}_{i.get("transactionHash", idx)}_{i["blockHash"]}',
                "blockNumber": i["blockNumber"],
                "trace": str(i)
            })

    return {
        'statusCode': 200,
        'blockNumber': 12914945,
        'traces_inserted': len(response["result"])
    }