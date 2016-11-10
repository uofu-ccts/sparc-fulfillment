#!/usr/bin/env bash

# load rvm ruby
source /Users/shanhong/.rvm/environments/ruby-2.1.5

export RAILS_ENV=test
# cd to project directory
cd /Volumes/HD2/projects/uofu/sparc-fulfillment
mkdir -p public/system/documents
cp .env .env.back
cp dotenv.example .env
today=`date +%Y-%m-%d-%H-%M-%S`
echo "bundle exec rspec --color --format documentation --out tmp/${today}-test-results"
rvm 2.1.5 do bundle exec rspec --color --format documentation --out tmp/${today}-test-results
cp .env.back .env
