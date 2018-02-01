'use strict';

const { execSync } = require('child_process');

const _ = require('lodash');
const request = require('request-promise');

const uri = process.env.SLACK_URI || require('./config').slack.uri;
const { getArticles } = require('./scrape');

(async () => {
  console.log('Getting articles...');
  const list = await getArticles();
  console.log(list);
  const { href, innerText } = _.sample(list);
  const text = `今日の記事:「${innerText}」\n${href}`;
  console.log(text);
  const opts = {
    method: 'POST',
    uri,
    headers: {
      'Content-Type': 'application/json'
    },
    body: { text },
    json: true
  };
  // await request(opts);
  execSync(`sh ./pull-request.sh ${href}`);
})();
