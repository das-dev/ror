# frozen_string_literal: true

require_relative '../helpers/manufacturer_info'
require_relative '../helpers/instance_counter'
require_relative 'exceptions'

# rubocop disable Style/Documentation
class Carriage
  attr_reader :type, :number

  include ManufacturerInfo
  include InstanceCounter

  NUMBER_FORMAT = /^[a-zA-Z0-9-]+$/

  def initialize(type, number)
    @number = number
    @type = type
    validate!
  end

  def validate!
    raise ValidationError, 'Invalid number format' if number !~ NUMBER_FORMAT
  end

  def to_s
    "##{number}"
  end
end
# rubocop enable all
