# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'fulfillment'
set :repo_url, 'git@github.com:sparc-request/sparc-fulfillment.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/rails/fulfillment'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/faye.yml', 'config/shards.yml', '.env', '.ruby-version', '.ruby-gemset')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', ENV.fetch('DOCUMENTS_FOLDER'))

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # restart Faye server
      within current_path do
        execute :bundle, "exec thin -C config/faye.yml stop"
        execute :bundle, "exec thin -C config/faye.yml start"
      end
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end


namespace :setup do
  desc "backup all configuration fiels"
  task :backup_config do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake backup:config"
          download! "#{current_path}/tmp/config_yml.zip", "tmp/#{fetch(:rails_env)}_config_yml.zip"
        end
      end
    end
  end

  desc "Upload database.yml file."
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml.example")), "#{shared_path}/config/database.yml"
      upload! StringIO.new(File.read("config/secrets.yml")), "#{shared_path}/config/secrets.yml"
      upload! StringIO.new(File.read("config/faye.yml.example")), "#{shared_path}/config/faye.yml"
      upload! StringIO.new(File.read("config/shards.yml.example")), "#{shared_path}/config/shards.yml"
      upload! StringIO.new(File.read("dotenv.example")), "#{shared_path}/.env"
      upload! StringIO.new(File.read(".ruby-version")), "#{shared_path}/.ruby-version"
      upload! StringIO.new(File.read(".ruby-gemset")), "#{shared_path}/.ruby-gemset"
    end
  end

end

after "deploy:restart", "delayed_job:restart"
