#!/bin/sh
#!/bin/sh
#
# https://docs.github.com/en/rest/reference/orgs#list-organizations
# 
# Usage: ls-orgs.sh
#
# Note: GITHUB_TOKEN can be set in .env file
#


if [ -f '.env' ]
then 
  source .env
fi

REQ_URL=https://api.github.com/organizations

echo $REQ_URL
curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  $REQ_URL