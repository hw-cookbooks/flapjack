#
# Cookbook:: flapjack
# Recipe:: _config
#
# Copyright:: 2014, Heavy Water Operations, LLC.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

directory '/etc/flapjack' do
  recursive true
  owner node['flapjack']['user']
  group node['flapjack']['group']
  mode '0755'
end

%w(
  pid_file
  log_file
).each do |option|
  directory File.dirname(node['flapjack']['config'][option]) do
    recursive true
    owner node['flapjack']['user']
    group node['flapjack']['group']
    mode '0755'
  end
end

data_bag_name = node['flapjack']['gateways']['data_bag']['name']
chef_environment_specific = node['flapjack']['gateways']['data_bag']['chef_environment_specific']

gateway_items = data_bag(data_bag_name).map do |item|
  gateway = data_bag_item(data_bag_name, item).to_hash
  config = chef_environment_specific ? gateway[node.chef_environment] : gateway.dup
  if config.nil?
    next
  else
    config.delete('id')
    [gateway['id'], config]
  end
end.compact

gateways = Hash[gateway_items]

environment = Flapjack.to_hash(node['flapjack']['config'])
environment['gateways'].merge!(gateways)

config = { node['flapjack']['environment'] => environment }

file '/etc/flapjack/flapjack_config.yaml' do
  content YAML.dump(config)
  owner node['flapjack']['user']
  group node['flapjack']['group']
  mode '0750'
end
