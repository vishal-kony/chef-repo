#
# Cookbook Name:: database_setter
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'postgresql::server'
include_recipe 'postgresql::client'
include_recipe 'database::postgresql'

node.default['postgresql']['pg_hba'] = 
[
	{:comment => '#Authentication',:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'trust'},
	{:comment => '#Ipv4 Connections',:type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'md5'},
	{:comment => '#Ipv6 Connections',:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
]

node.default['postgresql']['config']['listen_addresses'] = '*'

ruby_block "replacing_settings_text" do
	block do
		b = search(:node, "role:psql")
		print b
	end
	action :run
end