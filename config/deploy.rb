# config valid only for Capistrano 3.1
# lock '3.1.0'

set :application, 'baoxiao'
set :repo_url, 'git@github.com:jimhj/baoxiao.git'
set :deploy_to, -> { "/home/xiao/www/#{fetch(:application)}" }
set :rails_env, 'production'
set :rvm_type, :user
set :rvm_ruby_version, '2.1.0'

set :linked_files, %w{config/database.yml config/secrets.yml config/config.yml config/newrelic.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :keep_releases, 10
set :default_shell, '/bin/bash -l'

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# set :delayed_job_server_role, :worker
set :delayed_job_args, "-n 2"

namespace :deploy do
 desc "Start Application"
  task :start do
    on roles(:app) do
      execute :bundle, 'exec unicorn_rails -c config/unicorn.rb -D'
    end
  end

  desc "Stop Application"
  task :stop do
    on roles(:app) do
      execute "kill -QUIT `cat #{current_path}/tmp/pids/unicorn.pid`"
    end
  end

  desc "Restart Application"
  task :restart do
    on roles(:app) do
      execute "kill -USR2 `cat #{current_path}/tmp/pids/unicorn.pid`"
      invoke 'delayed_job:restart'
    end
  end

  desc "Rebuild Elasticsearch Indexs"
  task :rebuild_search_indexs do
    on roles(:app) do
      with :rails_env => :production do
        # execute "cd #{current_path} && bundle exec rake environment elasticsearch:import:model CLASS='Joke' FORCE=y"
        execute :bundle, "exec rake environment elasticsearch:import:model CLASS='Joke' FORCE=y"
      end
    end
  end

  desc "Refresh Sitemap"
  task :refresh_sitemap do
    on roles(:app) do
      with :rails_env => :production do
        rake 'sitemap:refresh:no_ping'
      end
    end
  end

  before 'deploy:start', 'rvm:hook'
  after :publishing, 'deploy:restart'
  after 'deploy:restart', 'deploy:refresh_sitemap'
end
