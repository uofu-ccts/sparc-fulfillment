export RAILS_ENV=test
mkdir -p public/system/documents
cp .env .env.back
cp dotenv.example .env
today=`date +%Y-%m-%d-%H-%M-%S`
bundle exec rspec --color --format documentation --out tmp/${today}-test-results
cp .env.back .env
