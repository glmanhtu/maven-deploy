#
# Cookbook Name:: maven-deploy
# Recipe:: forward
#
# Copyright 2017, glmanhtu
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef_nginx::source'

if node['maven-deploy']['forward']['enable']
    template "/etc/nginx/sites-available/#{node['maven-deploy']['forward']['from']['host']}.forward.conf" do
      source 'server-forward.conf.erb'
      mode '0755'
      owner 'root'
      group 'root'
      variables({
        server_port: node['maven-deploy']['forward']['from']['port'],
        server_hostname: node['maven-deploy']['forward']['from']['host'],
        server_forward_host: node['maven-deploy']['forward']['to']['host'],
        server_forward_port: node['maven-deploy']['forward']['to']['port']
      })
    end

    nginx_site "#{node['maven-deploy']['forward']['from']['host']}.forward.conf" do
      enable true
    end
else
  Chef::Log.debug('Ignore forwarding host')
end