#!/bin/sh
#
# Delete group: api :delete, “/organizations/#{@linked_org.id}/team/#{@linked_team.id}/external-groups”
# 
# Usage: rm-group-from-team.sh <org-id> <team-id>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org id: 88687631
#  Example team id: 5132882

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=https://api.github.com/organizations/$1/team/$2

echo $REQ_URL

curl \
  -X DELETE \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL