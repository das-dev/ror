# frozen_string_literal: true

# rubocop disable Style/Documentation
class Carriage
  attr_reader :type, :number

  def initialize(type, number)
    @number = number
    @type = type
  end
end
# rubocop enable all