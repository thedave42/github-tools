#!/bin/sh
# 
# Usage: ls-analysis.sh <org> <repo>
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=https://api.github.com/repos/$1/$2/code-scanning/analyses

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL
  
