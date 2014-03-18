include Flapjack

action :create do
  create_entity(new_resource.info, new_resource.name)
  new_resource.updated_by_last_action(true)
end
