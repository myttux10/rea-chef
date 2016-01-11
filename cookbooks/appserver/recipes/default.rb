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

