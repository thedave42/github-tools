#!/bin/sh
# 
# Usage: create-project-card.sh <column_id>
#   column_id - The unique ID of the column where the card will be created (required)
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/projects/columns/$1/cards

echo $REQ_URL

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  -d "{ \"content_id\": $2, \"content_type\": \"Issue\" }"
  
