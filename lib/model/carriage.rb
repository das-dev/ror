# frozen_string_literal: true

require_relative '../helpers/manufacturer_info'

# rubocop disable Style/Documentation
class Carriage
  attr_reader :type, :number

  include ManufacturerInfo

  def initialize(type, number)
    @number = number
    @type = type
  end

  def to_s
    "##{number}"
  end
end
# rubocop enable all
