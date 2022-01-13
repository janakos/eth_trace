#!/bin/bash

START=0
END=0

read -p "Starting Block --> " START
read -p "Ending Block -> " END

ARN=`aws resourcegroupstaggingapi get-resources --tag-filters Key=Name,Values=eth_block_sns | grep -Eo 'arn.*\w'`

echo $ARN
for i in $(seq $START $END); do
  aws sns publish --topic-arn $ARN --message $i
done