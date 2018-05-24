#!/usr/bin/env sh
export SENTRY_URL=https://863e60bbef39406896d2b7a5dbd491bb@sentry.io/1212848
BACKEND_URL=tcp://ec2-54-229-174-79.eu-west-1.compute.amazonaws.com:6777
parsec core --log-level=DEBUG --log-file ~/.config/parsec/parsec-core.log --I-am-John -A ${BACKEND_URL} &
sleep 1
core_pid=$!
parsec-electron
kill $core_pid
