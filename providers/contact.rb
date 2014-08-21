include Flapjack

def load_current_resource
  @contact_id = new_resource.name
  @contact_info = new_resource.info
end

action :create do
  unless contact_exists?(@contact_id)
    create_contact(@contact_id, @contact_info)
  end
  notification_rules = @contact_info["notification_rules"]
  if notification_rules.is_a?(Array)
    update_notification_rules(@contact_id, notification_rules)
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  if contact_exists?(@contact_id)
    delete_contact(@contact_id)
    new_resource.updated_by_last_action(true)
  end
end
