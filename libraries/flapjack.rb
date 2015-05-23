module Flapjack
  class << self

    def initialize
      require 'rest_client'
    end

    def to_hash(raw_hash)
      new_hash = {}
      raw_hash.each do |k, v|
        new_hash[k] = v.is_a?(Hash) ? to_hash(v) : v
      end
      new_hash
    end
  end

  def contact_exists?(id)
    get("contacts/#{id}").code == 200
  rescue RestClient::Exception
    false
  end

  def get_contact(id)
    response = get("contacts/#{id}")
    parsed = JSON.parse(response.body)
    parsed['contacts'].first
  end

  def create_contact(id, info)
    info['id'] ||= id
    raw_hash = {
      'contacts' => [info]
    }
    post('contacts', raw_hash)
  end

  def delete_contact(id)
    delete("contacts/#{id}")
  rescue RestClient::Exception => error
    Chef::Log.warn "Encountered an error while deleting Flapjack contact: #{id} - #{error}"
  end

  def get_contact_media_ids(id)
    contact = get_contact(id)
    contact['links']['media'].join(',')
  end

  def get_contact_media(id)
    media_ids = get_contact_media_ids(id)
    response = get("media/#{media_ids}")
    parsed = JSON.parse(response.body)
    parsed['media']
  end

  def create_contact_media(id, info)
    raw_hash = {
      'media' => info
    }
    post("contacts/#{id}/media", raw_hash)
  end

  def delete_contact_media(id)
    media_ids = get_contact_media_ids(id)
    begin
      delete("media/#{media_ids}")
    rescue RestClient::Exception => error
      Chef::Log.warn "Encountered an error while deleting Flapjack media: #{media_ids} - #{error}"
    end
  end

  def get_contact_notification_rules_ids(id)
    contact = get_contact(id)
    contact['links']['notification_rules'].join(',')
  end

  def get_contact_notification_rules(id)
    rules_ids = get_contact_notification_rules_ids(id)
    response = get("notification_rules/#{rules_ids}")
    parsed = JSON.parse(response.body)
    parsed['notification_rules']
  end

  def delete_contact_notification_rules(id)
    rules_ids = get_contact_notification_rules_ids(id)
    begin
      delete("notification_rules/#{rules_ids}")
    rescue RestClient::Exception => error
      Chef::Log.warn "Encountered an error while deleting Flapjack notification rules: #{rules_ids} - #{error}"
    end
  end

  def create_contact_notification_rules(id, info)
    raw_hash = {
      'notification_rules' => info
    }
    post("contacts/#{id}/notification_rules", raw_hash)
  end

  def create_entity(id, info)
    info['id'] ||= id
    raw_hash = {
      'entities' => [info]
    }
    post('entities', raw_hash)
  end

  private

  def api_uri
    port = node['flapjack']['config']['gateways']['jsonapi']['port']
    "http://localhost:#{port}"
  end

  def get(resource)
    RestClient.get "#{api_uri}/#{resource}", :accept => :json
  end

  def post(resource, raw_hash)
    RestClient.post "#{api_uri}/#{resource}", raw_hash.to_json, :content_type => :json, :accept => :json
  end

  def delete(resource)
    RestClient.delete "#{api_uri}/#{resource}"
  end
end
