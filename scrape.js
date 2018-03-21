'use strict';

const fs = require('fs');
const path = require('path');

const _ = require('lodash');
const Aigle = require('aigle');
const puppeteer = require('puppeteer');

const history = fs.readFileSync(path.resolve(__dirname, 'history'), 'utf8');
const historyMap = _.chain(history)
  .trim()
  .split('\n')
  .transform((map, text) => map[text] = text, {})
  .value();

Object.assign(exports, { getArticles });

const url = 'https://www.google.co.jp/search?tbm=nws&q=%E7%9D%A1%E7%9C%A0%E3%80%80%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9';
const words = [
  '不足',
  '病',
  '原因',
  '血圧',
  '死',
  '症',
  '質',
  '負',
  '免疫',
  '悪',
  'ミス'
];
const re = new RegExp(words.join('|'));

async function getArticles() {
  const browser = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
  const page = await browser.newPage();

  // set logal storage
  let count = 0;
  const tester = list => !list.length && ++count < 10;
  const iterator = async () => {
    const u = count ? `${url}&start=${count*10}` : url;
    const list = await getResult(u);
    console.log(`page:${count}\n`, _.map(list, 'innerText'));
    // return _.filter(list, ({ href, innerText }) => !historyMap[href] && re.test(innerText));
    return _.filter(list, ({ href }) => !historyMap[href]);
  }
  const result = await Aigle.doWhilst(iterator, tester);
  await browser.close();

  return result;

  async function getResult(url) {
    await page.goto(url);
    return await page.evaluate(() => {
      const nodeList = document.querySelectorAll('._PMs');
      const result = [];
      nodeList.forEach(({ href, innerText }) => result.push({
        href,
        innerText
      }));
      return result;
    });
  }
}
