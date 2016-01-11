#
# Cookbook Name:: common
# Recipe:: default
#
#

# Directory to store chef related files and scripts
chef_config_dir="/var/chef/config"
directory chef_config_dir do
 action :create
 mode 0750
 recursive true
end

if platform?("redhat", "centos") 
# EPEL yum repository bootstrap file
 template "#{chef_config_dir}/epel-bootstrap.repo" do
  source "epel-bootstrap.repo.erb"
  action :create
 end

# Install Yum epel-release packages if it's not already installed
 bash "Install EPEL Repo" do
   code <<-EOH
    cp #{chef_config_dir}/epel-bootstrap.repo /etc/yum.repos.d/epel-bootstrap.repo
    cp_exit_code=$? 

    yum --disablerepo=* --enablerepo=epel -y install epel-release
    yum_exit_code=$?

    rm  /etc/yum.repos.d/epel-bootstrap.repo
    rm_exit_code=$?

    if [[ cp_exit_code -ne 0 || yum_exit_code -ne 0 || rm_exit_code -ne 0 ]];
    then
     exit 1
    fi
    EOH
   not_if "rpm -qi epel-release"
 end

 node[:common][:rhel_devel_packages].each do |package_name|
  package package_name do
   action :install
  end
 end 


end
