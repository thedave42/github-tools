#!/bin/sh
#
# https://docs.github.com/en/rest/reference/teams#remove-team-membership-for-a-user
# 
# Usage: rm-group-from-team.sh <org> <team> <user>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org: Octocats
#  Example team: All-Employees
#  Example user: thedave42_github

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=$API_URL/orgs/$1/teams/$2/memberships/$3

echo $REQ_URL

curl \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL