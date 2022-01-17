#!/bin/bash

aws lambda invoke \
  --function-name store_traces_controller \
  --cli-binary-format raw-in-base64-out \
  --payload file://load_event.json \
  response.json