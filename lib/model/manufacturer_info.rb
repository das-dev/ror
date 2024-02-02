# frozen_string_literal: true

# rubocop:disable Style/Documentation
module ManufacturerInfo
  attr_accessor :manufacturer_name

  def initialize
    @manufacturer_name = nil
    super
  end
end
# rubocop:enable all
