#!/bin/sh
# 
# Usage: get-sarif.sh <org> <repo> <analysis_id>
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=https://api.github.com/repos/$1/$2/code-scanning/analyses/$3

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/sarif+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL
  