#
# Cookbook Name:: appserver
# Recipe:: default
#
template '/var/chef/config/install_ruby.sh' do
 source "install_ruby.sh.erb"
 action :create
 mode  0750
 user "root"
 group "root"
end

execute '/var/chef/config/install_ruby.sh' do
 action :run
end

#Install gems
#
#Path where we install our gems
gem_path="/usr/local/rvm/rubies/ruby-#{node[:appserver][:ruby][:default_version]}/bin/gem"

gem_package 'unicorn' do
 action :install
 gem_binary(gem_path)
end

#create app user
user node[:appserver][:app_user] do
  action :create
  comment 'App user'
  home '/home/sapp'
  shell '/bin/bash'
end

# Application base directory
directory node[:appserver][:app_base_dir] do
 action :create
 user node[:appserver][:app_user]
 mode 0755
 recursive true
end


#application directory

directory node[:appserver][:app_dir] do
 action :create
 user node[:appserver][:app_user]
 mode 0755
end


git "Rea Sinatra App" do
  repository node[:appserver][:git_repository]
  revision node[:appserver][:git_revision]
  action :sync
  destination node[:appserver][:app_dir]
end
