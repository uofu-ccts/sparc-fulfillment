cp .env .env.back
cp dotenv.example .env
bundle exec rspec
cp .env.back .env
