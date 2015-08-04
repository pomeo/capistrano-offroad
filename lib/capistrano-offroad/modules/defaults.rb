# My defaults for deployment, may or may nat be useful for anyone else.
require 'capistrano'

Capistrano::Configuration.instance(:must_exist).load do
  default_run_options[:pty] = true
  default_run_options[:shell] = '/bin/bash'
  set :scm, :git
  set :deploy_via,  :copy
  set :user,        "ubuntu"
  set :port,        2222
  set :copy_exclude,["/.git/", "/.gitignore", "/Capfile", "/config/", "/config.yaml", "/Rakefile", "Rules", "/tmp/", "/mkmf.log"]
  set :ssh_options, { :forward_agent => true }
  set :use_sudo, false
  set :deploy_to, "/home/ubuntu/www"
  set :deploy_user, "ubuntu"
  set :deploy_group,"ubuntu"

  namespace :deploy do
    desc "Install node modules non-globally"
    task :npm_install do
      run ". /home/ubuntu/.nvm/nvm.sh && cd #{current_path} && npm install --production"
    end
  end
end
