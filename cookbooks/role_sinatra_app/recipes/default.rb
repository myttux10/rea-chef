#
# Cookbook Name:: role_sinatra_app
# Recipe:: default
#
#
include_recipe "common"
include_recipe "webserver::nginx"
include_recipe "appserver::sinatra-unicorn-ruby"