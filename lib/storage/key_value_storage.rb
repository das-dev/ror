# frozen_string_literal: true

# rubocop:disable Style/Documentation
class KeyValueStorage
  def initialize
    @storage = Hash.new { |hsh, key| hsh[key] = [] }
  end

  def add_to_list(key, value)
    @storage[key] << value
  end

  def get(key, default = nil)
    @storage[key] || default
  end
end
# rubocop:enable all
