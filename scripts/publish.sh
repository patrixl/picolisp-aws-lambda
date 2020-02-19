#!/usr/bin/env bash

set -eu

AWS=`which aws`
NAME=$1
ZIP=$2
RUNTIME=$3

${AWS} lambda update-function-code --function-name ${NAME} --zip-file fileb://${ZIP}
arn=`${AWS} lambda publish-layer-version --layer-name ${RUNTIME} --zip-file fileb://picolisp.zip | jq -r '.LayerVersionArn'`
echo "New layer: ${arn}"
${AWS} lambda update-function-configuration --function-name piltest6 --layers ${arn}
