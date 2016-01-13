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

# Unicorn config directory
directory "/etc/unicorn" do
 action :create
 mode 0755
end


#Unicorn init file
template "/etc/init.d/unicorn" do
 source "unicorn.init.erb"
 action :create
 mode 0750
end

