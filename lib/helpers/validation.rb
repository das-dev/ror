# frozen_string_literal: true

module Validation
  class ValidationError < RuntimeError
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def validate(name, type, *)
      validators << Validators.make_validators(name, type, *)
    end

    def validators
      @validators ||= []
    end
  end

  def validate!
    self.class.validators.each do |validator|
      error_message, condition = validator.call(self)
      raise ValidationError, error_message if condition
    end
  end

  def valid?
    validate!
    true
  rescue ValidationError
    false
  end
end

module Validators
  def self.make_validators(name, type, *rest)
    {
      not_equal: ->(instance) { make_not_equal_validator(instance, name, *rest) },
      presence: ->(instance) { make_presence_validator(instance, name, *rest) },
      format: ->(instance) { make_format_validator(instance, name, *rest) },
      type: ->(instance) { make_type_validator(instance, name, *rest) },
      is: ->(instance) { make_is_validator(instance, name, *rest) }
    }[type] || ->(_) { ["", false] }
  end

  def self.make_presence_validator(instance, name, *)
    condition = value(instance, name).nil? || value(instance, name).empty?
    ["Field #{name} cannot be a nil or empty string", condition]
  end

  def self.make_format_validator(instance, name, pattern, *)
    condition = value(instance, name) !~ pattern
    ["Invalid #{name} format", condition]
  end

  def self.make_type_validator(instance, name, klass, *)
    condition = !value(instance, name).is_a?(klass)
    ["Field #{name} cannot be a nil or empty string", condition]
  end

  def self.make_is_validator(instance, name, predicate, *)
    condition = !value(instance, name).send("#{predicate}?")
    ["Field #{name} must be #{predicate}", condition]
  end

  def self.make_not_equal_validator(instance, name, other_name, *)
    condition = value(instance, name) == value(instance, other_name)
    ["Fields #{name} and #{other_name} must be different", condition]
  end

  def self.value(instance, name)
    instance.instance_variable_get("@#{name}")
  end
end
