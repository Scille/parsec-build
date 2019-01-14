#!/usr/bin/env bash
#
# This script accepts the following parameters:
#
# * owner
# * repo
# * tag
# * filename
# * github_api_token
#
# Example:
#
# upload-github-release-asset.sh github_api_token=TOKEN owner=stefanbuck repo=playground tag=v0.1.0 filename=./build.zip
#

# Check dependencies
set -e
xargs=$(which gxargs || which xargs)

# Validate settings
[ "$TRACE" ] && set -x

CONFIG=$@

for line in $CONFIG; do
  eval "$line"
done

# Define variables
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$owner/$repo"
AUTH="Authorization: token $github_api_token"
WGET_ARGS="--content-disposition --auth-no-challenge --no-cookie"
CURL_ARGS="-LJO#"

# Validate token
curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

# Create release
response=$(curl -sH "$AUTH" $GH_REPO/releases -X POST -H "Content-Type: application/json" --data "{\"name\": \"$tag\", \"tag_name\": \"$tag\", \"draft\": true, \"target_commitish\": \"snap-choco\"}")
release_url=$(echo "$response" | grep -oP '"upload_url":.+' | cut -d '"' -f 4 | cut -d '{' -f 1)

# Upload asset
echo "Uploading asset... "

# Construct url
GH_ASSET=$release_url?name=$(basename $filename)

curl --data-binary @"$filename" -H "Authorization: token $github_api_token" -H "Content-Type: application/octet-stream" $GH_ASSET
