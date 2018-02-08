#!/bin/sh

# Required environment variables
# GIT_URL: target github ssh url
GIT_BRANCH_NAME="circleci/update-history"
GITHUB_FILE="./github_secret";
HISTORY_FILENAME="history"
HISTORY_PATH=$PWD/$HISTORY_FILENAME

echo "Creating pull request..."

# setup git + hub
hub config user.email $GITHUB_EMAIL
hub config user.name $GITHUB_NAME
hub fetch origin
{
  hub checkout -b $GIT_BRANCH_NAME origin/$GIT_BRANCH_NAME
} || {
  hub checkout -b $GIT_BRANCH_NAME
}

echo test >> $HISTORY_FILENAME

# create commit
hub add $HISTORY_FILENAME
hub commit -m 'Update history by Circle CI [ci skip]'
hub push origin $GIT_BRANCH_NAME -f
hub pull-request -m "Update history by Circle CI"
