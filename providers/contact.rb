include Flapjack

action :create do
  info = new_resource.info
  create_contact(info, new_resource.name)
  if info["notification_rules"].is_a?(Array)
    previous_notification_rules = contact_notification_rules(new_resource.name).map do |rule|
      rule.delete("id")
      rule
    end
    notification_rules = info["notification_rules"].map do |rule|
      rule["contact_id"] = new_resource.name
      rule
    end
    unless previous_notification_rules == notification_rules
      notification_rules.each do |rule|
        create_notification_rule(rule)
      end
      previous_notification_rules.each do |rule|
        delete_notification_rule(rule["id"])
      end
    end
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  if contact_exists?(new_resource.name)
    notification_rules = contact_notification_rules(new_resource.name)
    notification_rules.each do |rule|
      delete_notification_rule(rule["id"])
    end
    delete_contact(new_resource.name)
    new_resource.updated_by_last_action(true)
  end
end
