import json
import requests


def handler(event, context):
    s = requests.Session()

    payload = {
        "jsonrpc": "2.0",
        "method": "trace_block",
        "params": [hex(12914945)],
        "id": 1
    }
    r = s.post(
        'https://eth-trace.gateway.pokt.network/v1/lb/61d91215fa95d4003afff1fd',
        json=payload,
        auth=('', 'b47d07bcc4754254f1cb7a30b2144f36')
    )

    return {
        'statusCode': 200,
        'body': json.dumps(r.json())
    }
