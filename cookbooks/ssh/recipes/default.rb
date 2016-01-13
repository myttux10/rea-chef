#
# Cookbook Name:: ssh
# Recipe:: default
#
#
#Configure SSH service
#
template "/etc/ssh/sshd_config" do
 source "sshd_config.erb"
 action :create
 mode 0600
 notifies :restart, 'service[sshd]'
end

service "sshd" do
 action [:enable,:start]
end
