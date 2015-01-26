require 'bundler/capistrano'
require "rvm/capistrano"

set :application, "Longbourn Web App"
set :repository,  "git@github.com:lvalenzuela/lb_comercial.git"
set :deploy_to, "/var/www/html/test_web_app"
set :scm, :git
set :branch, "test_branch"
set :user, "ubuntu"
set :group, "deployers"
set :use_sudo, false
set :rails_env, "production"
set :deploy_via, :copy
set :ssh_options, { :forward_agent => true }
set :keep_releases, 5
default_run_options[:pty] = true
server "54.205.158.154", :app, :web, :db, :primary => true 

set :rvm_ruby_string, :local        # use the same ruby as used locally for deployment

#before 'deploy', 'rvm:install_rvm'  # install/update RVM
before 'deploy', 'rvm:install_ruby' # install Ruby and create gemset (both if missing)

before "deploy:assets:precompile" do
  run ["ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml",
       "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml",
       "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml",
       "ln -nfs #{shared_path}/config/production.erb #{release_path}/config/environments/production.erb",
       "ln -fs #{shared_path}/uploads #{release_path}/uploads",
       "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  ].join(" && ")
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end

#  desc "Symlink shared config files"
#  task :symlink_config_files do
#   run "#{ sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
#    run "#{ sudo } ln -s #{ deploy_to }/shared/config/secrets.yml #{ current_path }/config/secrets.yml"
#  end

  # NOTE: I don't use this anymore, but this is how I used to do it.
  desc "Precompile assets after deploy"
  task :precompile_assets do
    run <<-CMD
      cd #{ current_path } &&
      #{ sudo } bundle exec rake assets:precompile RAILS_ENV=#{ rails_env }
    CMD
  end

  desc "Restart applicaiton"
  task :restart do
    run "#{ try_sudo } touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
  end
end

#after "deploy", "deploy:symlink_config_files"
#after "deploy", "deploy:precompile_assets"
#after "deploy", "deploy:restart"
after "deploy:update_code", "deploy:migrate"
after "deploy", "deploy:cleanup"