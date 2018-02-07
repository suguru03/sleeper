#!/bin/sh

# Required environment variables
# GIT_URL: target github ssh url
GIT_BRANCH_NAME="circleci/update-history"
GITHUB_FILE="./github_secret";
HISTORY_FILENAME="history"
HISTORY_PATH=$PWD/$HISTORY_FILENAME

# ruby
sudo apt-get install ruby-full
sudo gem install bundle

# setup hub
sudo apt-get install groff bsdmainutils
sudo ln -s /usr/local/go/bin/go /usr/bin/go

git clone https://github.com/github/hub.git
cd hub
git fetch --tags
git checkout -b v2.2.9
sudo make install
ls -a
which hub

cd ..

# setup git + hub
hub config user.email $GITHUB_EMAIL
hub config user.name $GITHUB_NAME
hub fetch origin
{
  hub checkout -b $GIT_BRANCH_NAME origin/$GIT_BRANCH_NAME
} || {
  hub checkout -b $GIT_BRANCH_NAME
}

# create commit
hub add $HISTORY_FILENAME
hub commit -m 'Update history by Circle CI [ci skip]'
hub push origin $GIT_BRANCH_NAME -f
hub pull-request -m "Update history by Circle CI"
