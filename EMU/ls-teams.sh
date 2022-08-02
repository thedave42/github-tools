#!/bin/sh
#!/bin/sh
#
# https://docs.github.com/en/rest/reference/teams#list-teams
# 
# Usage: ls-teams.sh <org>
#
# Note: GITHUB_TOKEN can be set in .env file
#
#  Example org: thedave42-Volcano

if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=https://api.github.com/orgs/$1/teams

echo $REQ_URL
curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL