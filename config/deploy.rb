# Copyright © 2011-2016 MUSC Foundation for Research Development~
# All rights reserved.~

# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:~

# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.~

# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following~
# disclaimer in the documentation and/or other materials provided with the distribution.~

# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products~
# derived from this software without specific prior written permission.~

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,~
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT~
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL~
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS~
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR~
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.~

# config valid only for current version of Capistrano
lock '3.4.0'

set :rvm_ruby_version, '2.1.5'

set :application, 'fulfillment'
set :repo_url, 'https://github.com/uofu-ccts/sparc-fulfillment'

# Default branch is :master
set :branch, ENV['branch'] || ask('Branch: ', nil)

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
set :linked_files, fetch(:linked_files, []).push('config/cas.yml', 'config/database.yml', 'config/secrets.yml', 'config/faye.yml', 'config/shards.yml', '.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', ENV.fetch('DOCUMENTS_FOLDER'))

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# to namespace the crontab entries by application and stage
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # restart Faye server
      within current_path do
        execute :bundle, "exec thin -C config/faye.yml stop"
        execute :bundle, "exec thin -C config/faye.yml start"
        execute :chmod, '777', 'tmp'
        execute :touch, 'tmp/restart.txt'
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
    end
  end

end

after "deploy:restart", "delayed_job:restart"
