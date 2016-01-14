# Chef Cookbooks to configure web application server on RHEL based distributiion

# Assumptions:
 The server to be provisioned has access to internet for downloading packages
 The server has IP address and DNS configured
 The server has connectivity to the cher server
 Server has a user configured with sudo privileges.

# Bootstrapping of new node
Instruction on using the Chef cookbooks

The chef workstation used for orchestration should be configured (config file knife.rb) with with credentials of administrative rights on the Cher server
For bootstrapping of nodes, knife.rb file should be configured as follows:
Note: replace value in `{...}` with appropriate values for your environment

```ruby
log_level                :info
log_location             STDOUT
node_name                '{chef client name who as adminstrative rights on chef server}'
client_key               '{path}/.chef/key.pem}'
validation_key            'nonexits'
chef_server_url          'https://{chef-server-url}:443/organizations/{organisation_name}'
syntax_check_cache_path  '{path}/.chef/syntax_check_cache'
cookbook_path [ '{/path/to/cookbook_folder}' ]
```
Place `knife.rb` file in `'{path}/.chef/`

`{path}` is usually home directory of a user in chef workstation with necessary chef-server keys with administrative privileges

In order to trust Chef server self-signed certificates, run
```
 knife ssl fetch
```

Upload cookbooks 'appserver'  'common'  'role_sinatra_app'  'ssh'  'webserver' to the chef server
``` knife cookbok upload -o {/path/to/cookbook_folder} appserver common role_sinatra_app ssh webserver ```

Once the bootstrapping is done, check if the application is working by doing
```
curl Node-IP-address

```
which should give output as `Hello World!`.

Note: One issue was observed during chef cookbook development. On CentOS 6.6 Virtualbox image configured via chef-server, the unicorn service was not started by chef for some reason(have not yet figured it out yet). However, on test machine provisioned using Test-Kitchen as mentioned below, chef was able to start the unicorn service.
If the `curl` command above gives html output with like `502 Bad Gateway` , log in to the machine and start uincorn
```
sudo service unicorn start
```

Application can also be started as follows

```
sudo su - sapp
cd /var/www/apps/rea
bundle install
bundle exec rackup
```
This will start application on WEBrick that comes with ruby.
Nginx has been configured to reverse-proxy to application on both unicorn and WEBrick. It will use unicorn backend by default


**Bootstart the node using knife**
```
knife bootstrap {node IP address} --ssh-user {administrative user on the node} --ssh-password  --sudo --use-sudo-password --node-name {NAME} --run-list 'recipe[role_sinatra_app]
```
## Testing on Vagrant + Virtualbox + test-kitchen ##
We can test the chef configuration on any machine which has vagrant, Virtualbox and test-kitchen

To create new node in virtualbox, from inside `role_sinatra_app` cookbook folder, run
```
kitchen converge
```

The application server can accessed at http://localhost:8080/ after `kitchen converge` completes successfully
Expected output: `Hello World!`

After testing, the machine can be deleted by running
```
kitchen destroy
```

Thie cookbooks will do the following:

## Configuration carried out by the coookbooks:
Five cookbooks, `common, appserver, webserver, ssh, role_sinatra_app`, have been created and used to configure the newly created os images.
* `coomon` cookbooks installs the packages packages for making environment ready to install and configure app-server (unicorn ) and proxy-server (nginx). It also enables 'Enforcing' mode of SElinux.
* `appserver` cookbook installs rvm, ruby, unicorn and bundler gem. It also configures the init script for unicorn server.
* `webserver` cookbook installs and configures nginx to be used as reverse proxy for the sinatra app that is going to be run on this server. It also configures SElinux Boolean and SElinux policy to enable nginx to connect to unix socket and any tcp ports.
* `ssh` cookbook is used to copy more robust configuration (sshd_config) for SSH server.
* `role_sinatra_app` is the wrapper cookbook which runs all above 4 cookbooks and carries configuration specific to the sinatra application such as setting of directory trees, fetching the application form git (https://github.com/rea-cruitment/simple-sinatra-app.git). It also starts unicorn service which starts all the applications that are specified in per application configuration in `/etc/unicorn/*.conf` files.






Areas for improvement
* update cookbooks to support Ubuntu
* Configure nginx with ModSecurity for security hardening
* Enable dynamic firewall configuration using LWRP. Cookbook uses static file to configure firewall
* Enable TLS in nginx useing Chef data bags to securely storiing keys.
* Enable monitoring of application

Tested on: 
Image: CentOS 6.7 x64
Chef-server: 12.0.7
chef-client: 12.6.0
Vagrant: 1.7.2
Berkshelf: 3.2.4
Test Kitchen: 1.4.2

