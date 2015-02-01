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
include_recipe 'database::postgresql'

node.default['postgresql']['pg_hba'] = 
[
	{:comment => '#Authentication',:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'trust'},
	{:comment => '#Ipv4 Connections',:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
	{:comment => '#Ipv6 Connections',:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
]

#creating database 'osqa'

postgresql_database 'osqa' do
  connection(
    :host      => '127.0.0.1',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  action :create
end

bash "osqa_install" do
  user "root"
  cwd "/home"
  code <<-EOH
  	svn co http://svn.osqa.net/svnroot/osqa/trunk/ osqa
  EOH
end

##########

python_pip "django" do
  version "1.3.1"
end

############


file_list = Array.new(['osqa.wsgi','osqa.conf','settings_local.py'])

for each_file in file_list
	file_path = ""
	case each_file
	when 'osqa.wsgi','settings_local.py'
		file_path = "/home/osqa/#{each_file}"
	else
		file_path = "/etc/apache2/sites-available/#{each_file}"
	end

	cookbook_file "#{each_file}" do
		path file_path
		atomic_update true
	end
end

#setting password and username for the database 

postgresuser = 'postgres'
postgrespass = ''
application_url = '10.0.2.15'

text = File.read('/home/osqa/settings_local.py')
text = text.gsub(/-pguser-/, postgresuser)
text = text.gsub(/-pgpass-/, postgrespass)
text = text.gsub(/-applicurl-/, application_url)

# To write changes to the file, use:
File.open('/home/osqa/settings_local.py', "w") {|file| file.puts text }