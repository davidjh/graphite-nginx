#
# Cookbook Name:: david
# Recipe:: nginx
#

include_recipe 'nginx'
include_recipe 'nginx::http_ssl_module'

service 'nginx' do
  action [ :start, :enable ]
  supports :restart => true, :reload => true, :status => true
end

template '/etc/nginx/conf.d/graphite.htpasswd' do
  source 'graphite.htpasswd.erb'
  mode 0600
  owner 'nginx'
  group 'nginx'
  notifies :reload, 'service[nginx]'
end

template "#{node['nginx']['dir']}/sites-available/graphite.com" do
  source 'graphite.conf.erb'
  mode 0644
  notifies :reload, 'service[nginx]'
end

nginx_site 'graphite.com' do
  action :enable
end

nginx_site '000-default' do
  enable false
end
