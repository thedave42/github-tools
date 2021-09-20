#!/bin/sh
#
# https://docs.github.com/en/rest/reference/teams#create-a-team
# 
# Usage: rm-group-from-team.sh <org-id> <team-id>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org: Volcano
#  Example team name: all-users

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=https://api.github.com/orgs/$1/teams

echo $REQ_URL

curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  -d "{\"name\":\"$2\"}"