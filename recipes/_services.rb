#
# Cookbook Name:: flapjack
# Recipe:: _services
#
# Copyright 2014, Heavy Water Operations, LLC.
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

include_recipe "runit"

ruby_block "flapjack_service_wait" do
  block do
    Chef::Log.info('Waiting for a Flapjack service to start ...')
    sleep 3
  end
  action :nothing
end

node["flapjack"]["services"].each do |service|
  runit_service service do
    options lazy {
      {
        :user => node["flapjack"]["user"],
        :ruby_bin_dir => node["flapjack"]["ruby_bin_dir"] || node["languages"]["ruby"]["bin_dir"]
      }
    }
    subscribes :restart, "file[/etc/flapjack/flapjack_config.yaml]"
    notifies :run, "ruby_block[flapjack_service_wait]", :immediately
  end
end
