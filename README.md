# Tiny Sea Bots Web

This is the web server for Tiny Sea Bots at [www.tinyseabots.com](http://www.tinyseabots.com)

## Requires
  Ruby

## Install/Update

Install basics

    bundle install

Configure
    The following environment variables can be configured (see ext/env.sample):

Run

    thin -R config.ru -P 5000
