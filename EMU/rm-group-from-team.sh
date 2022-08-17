#!/bin/sh
#
# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/external-groups#remove-the-connection-between-an-external-group-and-a-team
#
# Usage: rm-group-from-team.sh <org-name> <team-slug>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org name: Octocats
#  Example team slug: all-employees

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/orgs/$1/teams/$2/external-groups

echo $REQ_URL

curl \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL