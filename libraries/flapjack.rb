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
end
