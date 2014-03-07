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

  def contacts
    get("contacts")
  end

  def create_contact(info, id=nil)
    info["id"] = id if id
    raw_hash = {
      "contacts" => [info]
    }
    post("contacts", raw_hash)
  end

  def delete_contact(id)
    begin
      delete("contacts/#{id}")
    rescue RestClient::Exception => error
      Chef::Log.warn "Encountered an error while deleting Flapjack contact: #{id} - #{error}"
    end
  end

  private

  def api_uri
    port = node["flapjack"]["config"]["gateways"]["api"]["port"]
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
