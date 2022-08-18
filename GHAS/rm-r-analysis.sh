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

REQ_URL=$API_URL/repos/$1/$2/code-scanning/analyses
REF=$3
TOOL=$4

echo $REQ_URL
echo REF: $REF
echo TOOL: $TOOL

ANALYSIS_URL=$(curl -s \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  | jq --arg REF "$REF" --arg TOOL "$TOOL" -r '.[] | select((.ref == $REF) and (.deletable == true) and (.tool.name == $TOOL)) | {url}' \
  | jq -r '.url')


echo $ANALYSIS_URL

for URL in $ANALYSIS_URL  
do
  while [ "$URL" != "null" ] 
  do
    URL=$(curl -s \
    -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    $URL?confirm_delete \
    | jq -r '.next_analysis_url')
    echo $URL
  done
done


  