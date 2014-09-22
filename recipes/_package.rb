#
# Cookbook Name:: flapjack
# Recipe:: _package
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

platform_family = node["platform_family"]
case platform_family
when "debian"

  apt_repository "flapjack" do
    uri node["flapjack"]["apt_repo_uri"]
    distribution node["lsb"]["codename"]
    components ["main"]
  end

  package "flapjack" do
    version node["flapjack"]["version"]
    options "--force-yes"
  end

  service "flapjack" do
   action [ :enable, :start ]
  end

  service "redis-flapjack" do
   if node["flapjack"]["install_redis"]
     action [ :stop, :disable ]
   else
     action [ :enable, :start ]
     subscribes :restart, "file[/etc/flapjack/flapjack_config.yaml]"
   end
  end

else
  raise "A Flapjack package is not available for this platform family: #{platform_family}"
end

node.override["flapjack"]["ruby_bin_dir"] = node["flapjack"]["ruby_bin_dir"] || "/opt/flapjack/bin"
