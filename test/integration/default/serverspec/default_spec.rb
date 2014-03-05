require 'serverspec'
require 'net/http'
require 'uri'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
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
