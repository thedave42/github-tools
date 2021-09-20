#!/bin/sh

REPO=${GITHUB_REPOSITORY#*/}

curl \
  -X DELETE \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/thedave42/$REPO/code-scanning/analyses/$1