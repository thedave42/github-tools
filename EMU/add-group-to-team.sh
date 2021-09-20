#!/bin/sh
#
# Add/Update group to a team: api :patch, “/organizations/#{@org.id}/team/#{@team.id}/external-groups”, {}, input: { group_id: @external_group_ent2.id }.to_json
# 
# Usage: add-group-to-team.sh <org-id> <team-id> <group-id>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org id: 88687631
#  Example team id: 5132882
#  Example group id: 182

if [ -f '.env' ]
then 
  source .env
fi

ORG=thedave42-Volcano
REQ_URL=https://api.github.com/organizations/$1/team/$2/external-groups

echo $REQ_URL

curl \
  -X PATCH \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL \
  -d '{ "group_id": $3 }'