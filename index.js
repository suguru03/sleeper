'use strict';

const _ = require('lodash');
const request = require('request-promise');

const uri = process.env.SLACK_URI || require('./config').slack.uri;
const { getArticles } = require('./scrape');

(async () => {
  const list = await getArticles();
  const { href, innerText } = _.sample(list);
  const text = `今日の記事:「${innerText}」\n${href}`;
  const opts = {
    method: 'POST',
    uri,
    headers: {
      'Content-Type': 'application/json'
    },
    body: { text },
    json: true
  };
  await request(opts);
})();
