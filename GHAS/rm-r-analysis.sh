#!/bin/sh
# 
# Usage: rm-r-analysis.sh <org> <repo> <ref> <tool>
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=https://api.github.com/repos/$1/$2/code-scanning/analyses
REF=$3
TOOL=$4

echo $REQ_URL
echo REF: $REF
echo TOOL: $TOOL

ANALYSIS_URL=$(curl \
  -X GET \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  | jq --arg REF "$REF" --arg TOOL "$TOOL" -r '.[] | select((.ref == $REF) and (.deletable == true) and (.tool.name == $TOOL)) | {url}' \
  | jq -r '.url')

curl \
  -X DELETE \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $ANALYSIS_URL \
  