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

platform_family = node['platform_family']
case platform_family
when 'debian'
  apt_repository 'flapjack' do
    uri node['flapjack']['apt_repo_uri']
    distribution node['lsb']['codename']
    keyserver 'keys.gnupg.net'
    key '803709B6'
    components ['main']
  end

  deb_file = '/var/cache/apt/archives/flapjack_' + node['flapjack']['version']
  tmp_folder = '/tmp/flapjack'

  execute 'extract_flapjack' do
    command "dpkg-deb --extract #{deb_file}* #{tmp_folder} && cp -r #{tmp_folder}/* /"
    action :nothing
  end

  package 'flapjack' do
    version "#{node['flapjack']['version']}~#{node['lsb']['codename']}"
    options '--force-yes -d'
    notifies :run, 'execute[extract_flapjack]', :immediately
  end
else
  fail "A Flapjack package is not available for this platform family: #{platform_family}"
end

node.override['flapjack']['ruby_bin_dir'] = node['flapjack']['ruby_bin_dir'] || '/opt/flapjack/bin'
