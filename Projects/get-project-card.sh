#!/bin/sh
# 
# Usage: get-project-card.sh <card_id>
#   card_id - The unique ID of the card (required)
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=https://api.github.com/projects/columns/cards/$1

echo $REQ_URL

curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL
  
