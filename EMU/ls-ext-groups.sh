#!/bin/sh
#
# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/external-groups#list-external-groups-in-an-organization
# 
# Usage: ls-ext-groups.sh <org-name>
#
# Note: GITHUB_TOKEN can be set in .env file
#


if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/orgs/$1/external-groups

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL