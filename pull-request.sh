#!/bin/sh

# Required environment variables
# GIT_URL: target github ssh url
GIT_BRANCH_NAME="circleci/update-history"
HISTORY_FILENAME="history"
HISTORY_PATH=$PWD/$HISTORY_FILENAME

echo "Adding history... $1"
echo $1 >> $HISTORY_PATH

which node
which go
which ruby
node -v
npm -v
go version
ruby -v

sudo ln -s /usr/local/go/bin/go /usr/bin/go
sudo which go

git clone https://github.com/github/hub.git
cd hub
git fetch --tags
git checkout -b v2.2.9
sudo make install
ls -a
which hub
