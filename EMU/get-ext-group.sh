#!/bin/sh
#
# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/external-groups#get-an-external-group
# 
# Usage: get-ext-group.sh <org-name> <group-id>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org name: Octocats
#  Example group id: 182

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/orgs/$1/external-group/$2

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL