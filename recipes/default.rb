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
jar_name = node['maven-deploy']['jar']['name']
jar_location = "#{repo}/#{node['maven-deploy']['jar']['location']}/#{jar_name}"
jvm = node['maven-deploy']['jar']['arg']

directory source_dir do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0666'
  action :create
  recursive true
end

directory "/var/log/#{node['maven-deploy']['application']['name']}" do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
  recursive true
end

file "/tmp/git_wrapper.sh" do
  owner "ubuntu"
  mode "0755"
  content "#!/bin/sh\nexec /usr/bin/ssh -o \"StrictHostKeyChecking=no\" -i /home/ubuntu/.ssh/id_rsa \"$@\""
end

git repo do
  repository node['maven-deploy']['git']['url']
  branch node['maven-deploy']['git']['branch']
  action :sync
  ssh_wrapper "/tmp/git_wrapper.sh"
end

cookbook_file "/tmp/service.sh" do
  source "scripts/service.sh"
  mode 0755
end

bash 'stop current service' do
  code "./tmp/service.sh stop -e #{profile} -jar #{jar_location}"
  only_if { ::File.exist?("/var/run/#{jar_name}.#{profile.downcase}.pid") }
end

bash 'maven build project' do
  code "cd #{repo} && mvn clean install -DskipTests"
end

bash 'start service' do
  code "./tmp/service.sh start -e #{profile} -jar #{jar_location} -arg #{jvm}"
end