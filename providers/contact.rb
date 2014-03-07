include Flapjack

action :create do
  create_contact(new_resource.info, new_resource.name)
end

action :delete do
  delete_contact(new_resource.name)
end
