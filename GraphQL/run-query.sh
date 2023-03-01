#!/bin/sh
#
# Runs a GraphQL Query with optional Variable file
#
# Usage: run-query.sh <query-file> [variable-file]
#
# Note: GITHUB_TOKEN can be set in .env file
#

if [ -f '.env' ]
then 
  source .env
fi

if [ ! -f $1 ]
then
    echo "Usage: run-query.sh <query-file> [variable-file]"
    exit 1
fi

echo "Command line variables: $@"

echo "Using GraphQL Query file: $1"
QUERY=$(cat $1)
QUERY=$(echo $QUERY | sed 's/"/\\"/g')
echo "Query: $QUERY"
REQ_BODY="{\"query\": \"$QUERY\"}"

if [ -n "$2" ]
then
    echo "Using GraphQL Variable file: $2"
    VARS=$(cat $2)
    VARS=$(echo $VARS | sed 's/variables {/\"variables\": {/')
    echo "Variables: $VARS"
    REQ_BODY="{\"query\": \"$QUERY\", $VARS}"
fi

echo "Request Body: $REQ_BODY"

REQ_URL=$API_URL/graphql

echo "Request URL: $REQ_URL"

curl \
  -s -X POST \
  -H "Accept: application/json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d "$REQ_BODY" \
  $REQ_URL \
    | jq .