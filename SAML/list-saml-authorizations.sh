#!/bin/sh
# 
# Usage: list-saml-authorizations.sh <org>
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/orgs/$1/credential-authorizations

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL
  
