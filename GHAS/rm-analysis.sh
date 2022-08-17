#!/bin/sh
# 
# Usage: rm-analysis.sh <org> <repo> <analysis_id>
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi


REQ_URL=$API_URL/repos/$1/$2/code-scanning/analyses/$3

echo $REQ_URL

curl \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL
