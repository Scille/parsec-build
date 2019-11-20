#! /bin/sh

set -e
export SENTRY_ORG="scille"

curl -sL https://sentry.io/get-cli/ | bash

git clone https://github.com/Scille/parsec-cloud.git
cd parsec-cloud
sentry-cli --auth-token $SENTRY_RELEASE_TOKEN releases new -p parsec "$PARSEC_VERSION"
sentry-cli --auth-token $SENTRY_RELEASE_TOKEN releases set-commits --auto "$PARSEC_VERSION"
sentry-cli --auth-token $SENTRY_RELEASE_TOKEN releases finalize "$PARSEC_VERSION"
