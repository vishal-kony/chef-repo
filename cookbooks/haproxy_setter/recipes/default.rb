#
# Cookbook Name:: haproxy_setter
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'haproxy'

ips = Array.new
webnames = Array.new

webnodes = search(:node , "role:osqa")
webnodes.each do |node|
	ips.push(node["network"]["interfaces"]["eth1"]["addresses"].keys[1])
	webnames.push(node.name)
end

data = webnames.zip(ips)

data.each do |webset|
	node.default['haproxy']['members'] = [{
	  "hostname" => webset[0],
	  "ipaddress" => webset[1],
	  "port" => 80,
	}]
end