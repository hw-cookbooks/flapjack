actions :create, :delete

default_action :create

attribute :info, :kind_of => Hash, :default => Hash.new
