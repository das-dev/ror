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
  VALIDATORS = %i[comparison not_equal presence format type is].freeze

  def self.make_validators(name, type, *rest)
    VALIDATORS.each_with_object({}) do |validator, hash|
      hash[validator] = proc do |instance|
        method("make_#{validator}_validator").call(instance, name, *rest)
      end
    end[type] || ->(_) { ["", false] }
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

  def self.make_comparison_validator(instance, name, operator, other_name, *)
    condition = !value(instance, name).send(operator, value(instance, other_name))
    ["Fields #{name} and #{other_name} must be different", condition]
  end

  def self.make_not_equal_validator(instance, name, other_name, *)
    make_comparison_validator(instance, name, :!=, other_name, *)
  end

  def self.value(instance, name)
    instance.instance_variable_get("@#{name}")
  end
end
