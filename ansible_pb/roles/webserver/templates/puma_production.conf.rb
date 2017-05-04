directory '/home/deploy/demo/current'
rackup "/home/deploy/demo/current/config.ru"
environment 'production'
threads 4,16
workers 1

tag ''

shared_dir = "/home/deploy/demo/shared"

pidfile "/home/deploy/demo/shared/tmp/pids/puma.pid"
state_path "/home/deploy/demo/shared/tmp/pids/puma.state"
stdout_redirect '/home/deploy/demo/current/log/puma.error.log', '/home/deploy/demo/current/log/puma.access.log', true

bind 'unix:///home/deploy/demo/shared/tmp/sockets/puma_demo.sock'
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true


preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/deploy/demo/current/Gemfile"
end
