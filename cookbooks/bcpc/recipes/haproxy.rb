#
# Cookbook Name:: bcpc
# Recipe:: haproxy
#
# Copyright 2013, Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "bcpc::default"

make_config('haproxy-stats-user', "haproxy")

# backward compatibility
haproxy_stats_password = get_config("haproxy-stats-password")
if haproxy_stats_password.nil?
  haproxy_stats_password = secure_password
end

bootstrap = get_bootstrap

nodes = get_nodes_for("haproxy").map do |nn|
  begin
    nn['fqdn']
  rescue
    nil
  end
end.compact.join(',')

chef_vault_secret "haproxy-stats" do
  #
  # For some reason, we are compelled to specify a provider.
  # This will probably break if we ever move to chef-vault cookbook 2.x
  #
  provider ChefVaultCookbook::Provider::ChefVaultSecret

  data_bag 'os'
  raw_data({ 'password' => haproxy_stats_password })
  admins "#{ nodes },#{ bootstrap }"
  search '*:*'
  action :nothing
end.run_action(:create_if_missing)

package "haproxy" do
    action :upgrade
end

bash "enable-defaults-haproxy" do
  user "root"
  code <<-EOH
    sed --in-place '/^ENABLED=/d' /etc/default/haproxy
    echo 'ENABLED=1' >> /etc/default/haproxy
  EOH
  not_if "grep -e '^ENABLED=1' /etc/default/haproxy"
end

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  mode 00644
  variables(:mysql_servers => get_nodes_for("mysql","bcpc"))
  notifies :restart, "service[haproxy]", :immediately
end

service "haproxy" do
  restart_command "service haproxy stop && service haproxy start && sleep 5"
  action [ :enable, :start ]
end
