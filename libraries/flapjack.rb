module Flapjack
  class << self
    def to_hash(raw_hash)
      new_hash = {}
      raw_hash.each do |k, v|
        new_hash[k] = v.kind_of?(Hash) ? to_hash(v) : v
      end
      new_hash
    end
  end

  def contact_exists?(id)
    begin
      get("contacts/#{id}").code == 200
    rescue RestClient::Exception
      false
    end
  end

  def create_contact(id, info)
    info["id"] ||= id
    raw_hash = {
      "contacts" => [info]
    }
    post("contacts", raw_hash)
  end

  def get_contact(id)
    response = get("contacts/#{id}")
    parsed = JSON.parse(response.body)
    parsed["contacts"].first
  end

  def delete_contact(id)
    begin
      delete("contacts/#{id}")
    rescue RestClient::Exception => error
      Chef::Log.warn "Encountered an error while deleting Flapjack contact: #{id} - #{error}"
    end
  end

  def update_notification_rules(id, info)
    contact = get_contact(id)
    rules_id = contact["links"]["notification_rules"].first
    patch("notification_rules/#{rules_id}", info)
  end

  def create_entity(id, info)
    info["id"] ||= id
    raw_hash = {
      "entities" => [info]
    }
    post("entities", raw_hash)
  end

  private

  def api_uri
    port = node["flapjack"]["config"]["gateways"]["jsonapi"]["port"]
    "http://localhost:#{port}"
  end

  def get(resource)
    RestClient.get "#{api_uri}/#{resource}", :accept => :json
  end

  def post(resource, raw_hash)
    RestClient.post "#{api_uri}/#{resource}", raw_hash.to_json, :content_type => :json, :accept => :json
  end

  def patch(resource, raw_hash)
    RestClient.patch "#{api_uri}/#{resource}", raw_hash.to_json, :content_type => "application/json-patch+json", :accept => :json
  end

  def delete(resource)
    RestClient.delete "#{api_uri}/#{resource}"
  end
end
