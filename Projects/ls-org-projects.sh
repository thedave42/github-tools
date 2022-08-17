#!/bin/sh
# 
# Usage: ls-org-projects.sh <org>
#   org - The name of the Organization (required) 
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/orgs/$1/projects?per_page=100

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL 
  
