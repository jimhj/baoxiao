# config valid only for Capistrano 3.1
# lock '3.1.0'

set :application, 'baoxiao'
set :repo_url, 'git@github.com:jimhj/baoxiao.git'
set :deploy_to, -> { "/home/xiao/www/#{fetch(:application)}" }
set :rails_env, 'production'
set :rvm1_ruby_version, "2.1.0"

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :keep_releases, 10

namespace :deploy do
 desc "Start Application"
  task :start do
    on roles(:app) do
      execute "cd #{current_path}; RAILS_ENV=production bundle exec unicorn_rails -c config/unicorn.rb -D"
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
    end
  end

  before 'deploy:start', 'rvm1:hook'
  after :publishing, 'deploy:restart'
end
