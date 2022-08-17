#!/bin/sh
# 
# Usage: ls-org-project-columns.sh <project_id>
#   project_id - The ID of the Project (required) 
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/projects/$1/columns?per_page=100

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL
  
