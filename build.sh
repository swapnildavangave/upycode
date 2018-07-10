#! /usr/bin/env bash

set -e
TAG="swapnildavan11/upycode"
docker build --build-arg BUILD_DATE=`date -u +”%Y-%m-%dT%H:%M:%SZ”` -t $TAG .
docker push $TAG
set -e