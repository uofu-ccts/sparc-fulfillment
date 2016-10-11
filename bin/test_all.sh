export RAILS_ENV=test
mkdir -p public/system/documents
cp .env .env.back
cp dotenv.example .env
bundle exec rspec
cp .env.back .env
