#!/bin/sh
#
# All groups (paging is supported): api :get, “/organizations/#{@org.id}/external-groups”, [per_page: 30, page: 1...]
# 
# Usage: ls-ext-groups.sh <org-id>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org id: 88687631


if [ -f '.env' ]
then 
  source .env
fi

ORG=thedave42-Volcano
#REQ_URL=https://api.github.com/organizations/$1/external-groups
REQ_URL=https://api.github.com/orgs/$1/external-groups

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL