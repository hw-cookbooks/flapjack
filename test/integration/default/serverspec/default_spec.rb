require 'serverspec'
require 'net/http'
require 'uri'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/local/bin:/sbin:/usr/sbin'
  end
end

describe command('ruby -e \'require "flapjack"\'') do
  it { should return_exit_status 0 }
end

describe process("redis-server") do
  it { should be_running }
end

describe port(6379) do
  it { should be_listening }
end

describe file("/etc/flapjack") do
  it { should be_directory }
end

describe file("/etc/flapjack/flapjack-config.yml") do
  it { should be_file }
end

describe file("/etc/flapjack/flapjack-config.yml") do
  its(:content) { should match /smtp_config/ }
end
