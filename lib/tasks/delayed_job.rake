namespace :util do
  desc 'start delayed job'
  task :start_delayed_job => :environment do
    `bundle exec bin/delayed_job restart`
  end

  desc 'start faye server'
  task :start_thin_server => :environment do
    `thin -C config/faye.yml start`
  end

  desc 'start all'
  task :start_all => :environment do
    `thin -C config/faye.yml restart`
    `bundle exec bin/delayed_job restart`
  end


end
