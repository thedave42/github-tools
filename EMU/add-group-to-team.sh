#!/bin/sh
#
# Add/Update group to a team:
# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/external-groups#update-the-connection-between-an-external-group-and-a-team
# 
# Usage: add-group-to-team.sh <org> <team-slug> <group-id>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org: Octocats
#  Example team slug: all-employees
#  Example group id: 182

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/orgs/$1/teams/$2/external-groups

echo $REQ_URL

curl \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  -d "{ \"group_id\": $3 }"
