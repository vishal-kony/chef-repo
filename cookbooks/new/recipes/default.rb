#
# Cookbook Name:: new
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'postgresql::server'
include_recipe 'postgresql::client'

node.default['postgresql']['pg_hba'] = 
[
	{:comment => '#Authentication',:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'trust'},
	{:comment => '#Ipv4 Connections',:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
	{:comment => '#Ipv6 Connections',:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
]
