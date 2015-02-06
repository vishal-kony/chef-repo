# -*- mode: ruby -*-

Vagrant.configure(2) do |config|
  (1..5) .each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "opscode-ubuntu-14.04"
      node.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
      node.vm.network "forwarded_port", guest: 80, host: 4567+i
      node.vm.provision :chef_client do |chef|
        chef.chef_server_url = "https://api.opscode.com/organizations/vish_sharma"
        chef.validation_key_path = "./.chef/vish_sharma-validator.pem"
        chef.validation_client_name = "vish_sharma-validator"
        chef.node_name = "node_#{i}"
    	  chef.add_role "osqa"
      end
    end
  end
end