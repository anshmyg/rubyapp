server '54.187.186.197', port: 22, roles: [:web, :app, :db], primary: true

set :user,            'deploy'

set :repo_url,        'git://github.com/anshmyg/rubyapp'
set :application,     'demo'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    1

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma_#{fetch(:application)}.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user) }
set :puma_preload_app, true
set :puma_worker_timeout, nil

namespace :puma do
  desc 'Create Directories for Puma Pids'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
      execute "mkdir #{shared_path}/log -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end
  
  desc 'Delete ansible dir' 
  task :remove_ansible_dir do
    on roles(:app) do
      execute "rm -rf #{release_path}/ansible_pb"
    end
  end  

  before :starting,     :check_revision
  after  :finishing,    :remove_ansible_dir
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end

