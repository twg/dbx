module DBX::Support
  def symbolize_keys(hash)
    Hash[
      hash.collect do |k, v|
        [
          k ? k.to_sym : k,
          v.is_a?(Hash) ? symbolize_keys(v) : v
        ]
      end
    ]
  end
  
  extend self
end
