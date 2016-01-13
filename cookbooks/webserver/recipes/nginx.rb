#install nginx

package "nginx" do
 action :install
end

template "/etc/nginx/nginx.conf" do
 source "nginx.conf.erb"
 user "root"
 group "root"
 mode 0640
 notifies :reload, 'service[nginx]'
end

service "nginx" do
 action [:start, :enable]
end

#allow nginx to make connection to any tcp ports (proxying purposes)
execute 'Enable httpd_can_network_connect boolean' do
 command 'setsebool -P httpd_can_network_connect on'
 not_if 'getsebool httpd_can_network_connect|grep -E "on$"'
end

cookbook_file "/var/chef/config/reapolicy.te" do
 source "reapolicy.te"
 action :create
 mode 0644
end

policy_script="/var/chef/config/genreate_and_insert_pol.sh"
cookbook_file policy_script  do
 source "genreate_and_insert_pol.sh"
 action :create
 mode 0750
end

execute policy_script do
 cwd "/var/chef/config"
end

