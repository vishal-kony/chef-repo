#
# Cookbook Name:: new
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'python::default'
include_recipe 'apache2::mod_wsgi'
include_recipe 'postgresql::client'

cookbook_file "requirements.txt" do
	path "/var/tmp/requirements.txt"
	atomic_update true
end

bash "osqa_install" do
  user "root"
  cwd "/home"
  code <<-EOH
  	svn co http://svn.osqa.net/svnroot/osqa/trunk/ osqa
  	apt-get install dos2unix
  	pip install -r /var/tmp/requirements.txt
  EOH
end

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

	execute "dos2unix #{file_path}" do
		action :run
	end
end

dbnodes = search(:node, "role:psql")

#setting password and username for the database 
ruby_block "replacing_settings_text" do
	block do
		postgresuser = 'postgres'
		postgrespass = dbnodes[0]['postgresql']['password']['postgres']
		postgreshost = dbnodes[0]["network"]["interfaces"]["eth1"]["addresses"].keys[1]
		postgresport = '5432'
		application_url = node["ipaddress"]

		text = File.read('/home/osqa/settings_local.py')
		text = text.gsub(/-pguser-/, postgresuser)
		text = text.gsub(/-pgpass-/, postgrespass)
		text = text.gsub(/-applicurl-/, application_url)
		text = text.gsub(/-pghost-/, postgreshost)
		text = text.gsub(/-pgport-/, postgresport)
		# To write changes to the file, use:
		File.open('/home/osqa/settings_local.py', "w") do |file|
			file.write(text)
		end
	end
	action :run
end

bash "syncing_the_database" do
	user "root"
	cwd "/home/osqa"
	code <<-EOH
		echo "no" | python manage.py syncdb --all
	EOH
end

apache_site "osqa" do
	enable true
end

bash "own_the_resource" do
  user "root"
  cwd "/home"
  code <<-EOH
  	chown -R www-data:www-data osqa
  EOH
end