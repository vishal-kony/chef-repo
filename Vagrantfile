# -*- mode: ruby -*-

Vagrant.configure(2) do |config|

    config.vm.define "database" do |db|
      db.vm.box = "opscode-ubuntu-14.04"
      db.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
      db.vm.network "private_network", ip: '192.168.1.58'
      db.vm.provision :chef_client do |chef|
        chef.chef_server_url = "https://api.opscode.com/organizations/vish_sharma"
        chef.validation_key_path = "./.chef/vish_sharma-validator.pem"
        chef.validation_client_name = "vish_sharma-validator"
        chef.node_name = "database"
        chef.add_role "psql"
      end
    end

  app_servers = { 
                  :osqa1 => ['192.168.1.44', 0],
                  :osqa2 => ['192.168.1.45', 1],
                  :osqa3 => ['192.168.1.46', 2]
                }

  app_servers.each do |app_server_name, app_server_ip|
    config.vm.define app_server_name do |node|
      node.vm.box = "opscode-ubuntu-14.04"
      node.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
      #node.vm.network "forwarded_port", guest: 80, host: 4567+app_server_ip[1]
      node.vm.network "private_network", ip: app_server_ip[0]
      node.vm.provision :chef_client do |chef|
        chef.chef_server_url = "https://api.opscode.com/organizations/vish_sharma"
        chef.validation_key_path = "./.chef/vish_sharma-validator.pem"
        chef.validation_client_name = "vish_sharma-validator"
        chef.node_name = app_server_name.to_s;
    	  chef.add_role "osqa"
      end
    end
  end

  config.vm.define "balancer" do |bal|
      bal.vm.box = "opscode-ubuntu-14.04"
      bal.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
      bal.vm.network "forwarded_port", guest: 80, host: 5455
      bal.vm.network "private_network", ip: '192.168.1.10'
      bal.vm.provision :chef_client do |chef|
        chef.chef_server_url = "https://api.opscode.com/organizations/vish_sharma"
        chef.validation_key_path = "./.chef/vish_sharma-validator.pem"
        chef.validation_client_name = "vish_sharma-validator"
        chef.node_name = "balancer"
        chef.add_role "hacook"
      end
    end

end