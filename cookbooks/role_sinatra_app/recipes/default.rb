#
# Cookbook Name:: role_sinatra_app
# Recipe:: default
#
#
include_recipe "common"
include_recipe "appserver::sinatra-unicorn-ruby"
include_recipe "webserver::nginx"
app_user=node[:appserver][:app_user]
app_dir=node[:role_sinatra_app][:app_dir]

#IPtables configuration for this server
template "/etc/sysconfig/iptables" do
 source "iptables.erb"
 action :create
 mode 0644
 notifies :restart, 'service[iptables]'
end

service "iptables" do
 action [:enable, :start]
end

#application directory
directory app_dir do
 action :create
 user app_user
 group app_user
 mode 0755
end

git app_dir do
  repository node[:role_sinatra_app][:git_repository]
  revision node[:role_sinatra_app][:git_revision]
  action :sync
  user app_user
  group app_user
end

node[:role_sinatra_app][:dirs].each do |dir_name|
 directory "#{app_dir}/#{dir_name}" do
  action :create
  user app_user
  group app_user
  mode 0755
 end
end

#unicorn config for this app
template "#{app_dir}/config/unicorn.rb" do
 source "unicorn.rb.erb"
 action :create
 user app_user
 group app_user
 mode 0644
end


# app config files used by unicorn init script
template "/etc/unicorn/rea.conf" do
 source "rea.conf.erb"
 action :create
 user app_user
 group app_user
 mode 0644
end

template "/var/chef/config/install_app_bundle.sh" do
 source "install_app_bundle.sh.erb"
 action :create
 mode 0755
 variables(:app_dir => app_dir)
end

#Install gems from Gemfile if not already installed
execute '/var/chef/config/install_app_bundle.sh' do
  action :run
end

service 'unicorn' do
 action [:enable, :start]
end

