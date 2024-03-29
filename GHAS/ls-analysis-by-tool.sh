#!/bin/sh
# 
# Usage: ls-analysis.sh <org> <repo> <tool>
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/repos/$1/$2/code-scanning/analyses
TOOL=$3

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  | jq --arg TOOL "$TOOL" -r '.[] | select(.tool.name == $TOOL)'

