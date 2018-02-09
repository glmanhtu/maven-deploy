#
# Cookbook Name:: maven-deploy
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'maven-deploy::forward'

profile = node['maven-deploy']['profile']
source_dir = "#{node['maven-deploy']['dir']}/#{node['maven-deploy']['application']['name']}"
repo = "#{source_dir}/repo"
prevent_deploy_file = "#{source_dir}/#{node['maven-deploy']['application']['prevent-deploy-file']}"
jar_name = node['maven-deploy']['jar']['name']
jar_location = "#{repo}/#{node['maven-deploy']['jar']['location']}/#{jar_name}"
app_port = node['maven-deploy']['application']['port']
jvm = node['maven-deploy']['jar']['arg']
jvm = "#{jvm} -Dserver.port=#{app_port} -Dprevent.deploy.file=#{prevent_deploy_file}"

data_bag_name = node['maven-deploy']['git']['databag']['name']
data_bag_key = node['maven-deploy']['git']['databag']['key']
data_bag_property = node['maven-deploy']['git']['databag']['property']

private_ssh_key = ""
ssl = ""

if node['maven-deploy']['application']['ssl']['enable']
	ssl = "-Djavax.net.ssl.keyStore=#{node['maven-deploy']['application']['ssl']['key_store']}"
	ssl = "#{ssl} -Djavax.net.ssl.keyStorePassword=#{node['maven-deploy']['application']['ssl']['key_store_password']}"
	ssl = "#{ssl} -Djavax.net.ssl.trustStore=#{node['maven-deploy']['application']['ssl']['trust_store']}"
	ssl = "#{ssl} -Djavax.net.ssl.trustStorePassword=#{node['maven-deploy']['application']['ssl']['trust_store_password']}"
end

jvm = "#{jvm} #{ssl}"

directory source_dir do
  mode '0666'
  action :create
  recursive true
end

directory "/var/log/#{node['maven-deploy']['application']['name']}" do
  mode '0755'
  action :create
  recursive true
end


ruby_block "Check if application is running an important task " do
  block do
    if File.exists?(prevent_deploy_file)
    	status = true
    	while status == true
    		prevent_status = File.read(prevent_deploy_file)
      		if prevent_status == "true"
  			  	Chef::Log.info("Waiting for important task to be done!...")
      			sleep(30)
  			else
				status = false
			end
    	end
	else
		File.open(prevent_deploy_file, 'w') { |file| file.write("false") }
    end
  end
end

if node['maven-deploy']['git']['private']
	encrypted_key = Chef::EncryptedDataBagItem.load(data_bag_name, data_bag_key)
	private_ssh_key = encrypted_key[data_bag_property]

	file "/tmp/git_private_key" do
		mode "400"
		sensitive true
		content private_ssh_key
	end

	file "/tmp/git_wrapper.sh" do
	  mode "0755"
	  sensitive true
	  content "#!/bin/sh\nexec /usr/bin/ssh -o \"StrictHostKeyChecking=no\" -i /tmp/git_private_key \"$@\""
	end

	git repo do
	  repository node['maven-deploy']['git']['url']
	  branch node['maven-deploy']['git']['branch']
	  action :sync
	  ssh_wrapper "/tmp/git_wrapper.sh"
	end


	file "/tmp/git_private_key" do
		action :delete
	end
else
	
	file "/tmp/git_wrapper.sh" do
	  mode "0755"
	  content "#!/bin/sh\nexec /usr/bin/ssh -o \"StrictHostKeyChecking=no\" \"$@\""
	end

	git repo do
	  repository node['maven-deploy']['git']['url']
	  branch node['maven-deploy']['git']['branch']
	  action :sync
	  ssh_wrapper "/tmp/git_wrapper.sh"
	end
end

cookbook_file "/tmp/service.sh" do
  source "scripts/service.sh"
  mode 0755
end

bash 'stop current service' do
  code "./tmp/service.sh stop -e #{profile} -jar #{jar_location}"
  only_if { ::File.exist?("/var/run/#{jar_name}.#{profile.downcase}.pid") }
end

if node['maven-deploy']['application']['integration-test']
	bash 'maven integration-test project' do
	  code "cd #{repo} && mvn clean verify -P integration-test #{ssl}"
	end	
end

bash 'maven build project' do
  code "cd #{repo} && SPRING_PROFILES_ACTIVE=#{profile} mvn clean install #{ssl}"
end

bash 'start service' do
  code "./tmp/service.sh start -e #{profile} -jar #{jar_location} -arg #{jvm}"
end