#!/bin/sh

# Required environment variables
# GIT_URL: target github ssh url
GIT_BRANCH_NAME="circleci/update-history"
HISTORY_FILENAME="history"
HISTORY_PATH=$PWD/$HISTORY_FILENAME

echo "Adding history... $1"
echo $1 >> $HISTORY_PATH

git clone https://github.com/github/hub.git
cd hub
git fetch --tags
git checkout v2.2.9
./script/build
which hub
