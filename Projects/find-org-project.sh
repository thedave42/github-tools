#!/bin/sh
# 
# Usage: find-org-project.sh <org> <project_id> [page]
#   org - The name of the Organization (required) 
#   project_id - The ID of the project from the project URL
#   page - The page # of the results (defaults to 1)
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

if [ -z "$3" ]
then
  PAGE=1
else
  PAGE=$3
fi

REQ_URL=$API_URL/orgs/$1/projects?per_page=100\&page=$PAGE
HTML_URL=https://github.com/orgs/$1/projects/$2

echo html_url: $HTML_URL
echo $REQ_URL

PROJECT_ITEM=$(
  curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  | jq --arg HTML_URL "$HTML_URL" -r '.[] | select(.html_url == $HTML_URL) | .id' \
)
  
if [ "$PROJECT_ITEM" == "" ]
then 
  echo Not found on page $PAGE.
else 
  echo Project id: $PROJECT_ITEM
fi