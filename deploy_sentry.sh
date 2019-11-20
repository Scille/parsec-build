#! /bin/sh

set -e
set -v

# SENTRY_AUTH_TOKEN should be defined in travis environ variables
export SENTRY_PROJECT="parsec"
export SENTRY_ORG="scille"

curl -sL https://sentry.io/get-cli/ | bash

git clone https://github.com/Scille/parsec-cloud.git --branch="$PARSEC_VERSION" --depth=1
cd parsec-cloud

sentry-cli releases new "$PARSEC_VERSION"
sentry-cli releases set-commits --auto "$PARSEC_VERSION"
sentry-cli releases finalize "$PARSEC_VERSION"
