# frozen_string_literal: true

module Validation
  def valid?
    validate!
    true
  rescue ValidationError
    false
  end

  def validate!
    raise "Validation method should be defined in the class"
  end
end
