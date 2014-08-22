include Flapjack

def load_current_resource
  @contact_id = new_resource.name
  @contact_info = new_resource.info
end

def filter_hash(raw_hash, key_filter)
  raw_hash.reject { |key, value| key_filter.include?(key) }
end

def filter_hashes(raw_array, key_filter)
  raw_array.map { |raw_hash| filter_hash(raw_hash, key_filter) }
end

def flattened_comparison(object_one, object_two)
  object_one.to_a.flatten.sort == object_two.to_a.flatten.sort
end

def contact_info_changed?(previous, current)
  key_filter = %w[data_bag chef_type media notification_rules links]
  previous_filtered = filter_hash(previous, key_filter)
  current_filtered = filter_hash(current, key_filter)
  !flattened_comparison(previous_filtered, current_filtered)
end

def notification_rules_defaults
  {
    "tags" => nil,
    "regex_tags" => nil,
    "entities" => nil,
    "regex_entities" => nil,
    "time_restrictions" => nil,
    "unknown_media" => nil,
    "warning_media" => nil,
    "critical_media" => nil,
    "unknown_blackhole" => nil,
    "warning_blackhole" => nil,
    "critical_blackhole" => nil
  }
end

def notification_rules_changed?(previous, current)
  key_filter = %w[id links]
  previous_filtered = filter_hashes(previous, key_filter)
  current_with_defaults = current.map do |rules|
    notification_rules_defaults.merge(rules)
  end
  current_filtered = filter_hashes(current_with_defaults, key_filter)
  !flattened_comparison(previous_filtered, current_filtered)
end

action :create do
  if contact_exists?(@contact_id)
    previous_contact_info = get_contact(@contact_id)
    if contact_info_changed?(previous_contact_info, @contact_info)
      Chef::Log.info("Flapjack contact updated: #{@contact_id}")
      delete_contact(@contact_id)
      create_contact(@contact_id, @contact_info)
      new_resource.updated_by_last_action(true)
    end
  else
    Chef::Log.info("Creating Flapjack contact: #{@contact_id}")
    create_contact(@contact_id, @contact_info)
    new_resource.updated_by_last_action(true)
  end
  notification_rules = @contact_info["notification_rules"]
  if notification_rules.is_a?(Array)
    previous_notification_rules = get_contact_notification_rules(@contact_id)
    if notification_rules_changed?(previous_notification_rules, notification_rules)
      Chef::Log.info("Flapjack notification rules changed for contact: #{@contact_id}")
      delete_contact_notification_rules(@contact_id)
      create_contact_notification_rules(@contact_id, notification_rules)
    end
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if contact_exists?(@contact_id)
    Chef::Log.info("Deleting Flapjack contact: #{@contact_id}")
    delete_contact(@contact_id)
    new_resource.updated_by_last_action(true)
  end
end
