#!/bin/sh
#
# https://docs.github.com/en/rest/reference/teams#create-a-team
#    The API allows other parameters to be passed during team creation, but only Name is required.
#    See the documentation for additional parameters.  You can modify the below script to include
#    additional parameters as necessary.
# 
# Usage: create-team.sh <org-name> <team-name>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org: Octocats
#  Example team name: all-users

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/orgs/$1/teams

echo $REQ_URL

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  -d "{\"name\":\"$2\"}"