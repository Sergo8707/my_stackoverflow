# config valid only for current version of Capistrano
lock "3.8.1"
set :rvm_ruby_version, '2.3.0'

set :application, "my_stackoverflow"
set :repo_url, "git@github.com:Sergo8707/my_stackoverflow.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/my_stackoverflow"
set :deploy_user, 'deployer'

set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
# Default value for :linked_files is []
append :linked_files, ".env", "config/database.yml", "config/secrets.yml", "config/production.sphinx.conf", "config/sidekiq.yml"
# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads", "vendor/bundle", "db/sphinx/production"
# Default value for default_env is {}
set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end