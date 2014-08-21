include Flapjack

def load_current_resource
  @contact_id = new_resource.name
  @contact_info = new_resource.info
end

def contact_info_changed?(previous, current)
  previous.map { |r| r.reject { |k, v| %w[notification_rules links].include?(k) } } != current
end

def notification_rules_changed?(previous, current)
  previous.map { |r| r.reject { |k, v| k == "id" } } != current
end

action :create do
  if contact_exists?(@contact_id)
    previous_contact_info = get_contact(@contact_id)
    if contact_info_changed?(previous_contact_info, @contact_info)
      delete_contact(@contact_id)
      create_contact(@contact_id, @contact_info)
      new_resource.updated_by_last_action(true)
    end
  else
    create_contact(@contact_id, @contact_info)
    new_resource.updated_by_last_action(true)
  end

  notification_rules = @contact_info["notification_rules"]
  if notification_rules.is_a?(Array)
    previous_notification_rules = get_contact_notification_rules(@contact_id)
    if notification_rules_changed?(previous_notification_rules, notification_rules)
      delete_contact_notification_rules(@contact_id)
      create_contact_notification_rules(@contact_id, notification_rules)
    end
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if contact_exists?(@contact_id)
    delete_contact(@contact_id)
    new_resource.updated_by_last_action(true)
  end
end
