#!/bin/sh
#
# Single group: api :get, “/organizations/#{@org.id}/external-group/#{@external_group1.id}”
# 
# Usage: get-ext-group.sh <org-id> <group-id>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org id: 88687631
#  Example group id: 182

if [ -f '.env' ]
then 
  source .env
fi

ORG=thedave42-Volcano
REQ_URL=https://api.github.com/organizations/$1/external-group/$2

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL