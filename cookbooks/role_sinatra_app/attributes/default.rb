#include_attribute "webserver::default"
include_attribute "appserver::default"

default[:role_sinatra_app][:app_name]="rea"
default[:role_sinatra_app][:app_dir]="#{node[:appserver][:app_base_dir]}/#{node[:role_sinatra_app][:app_name]}"
#Git location of application
default[:role_sinatra_app][:git_repository]="https://github.com/rea-cruitment/simple-sinatra-app.git"
default[:role_sinatra_app][:git_revision]="master"
default[:role_sinatra_app][:dirs]=["config","tmp","tmp/pids","tmp/sockets","log","public"]
