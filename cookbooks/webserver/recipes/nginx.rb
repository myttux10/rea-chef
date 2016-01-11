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


