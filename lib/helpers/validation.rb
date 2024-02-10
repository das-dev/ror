# frozen_string_literal: true

module Validation
  class ValidationError < RuntimeError; end

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, type, *, **)
      validators << Validators.make_validator(name, type, *, **)
    end

    def validators
      @validators ||= []
    end
  end

  module InstanceMethods
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
end

module Validators
  STUB = ->(_) { ["", false] }
  VALIDATORS_NAMES = %i[comparison not_equal presence format type is].freeze

  def self.make_validator(name, type, *args, **options)
    return STUB unless VALIDATORS_NAMES.include?(type)

    lambda do |instance|
      method("make_#{type}_validator").call(instance, name, *args, **options)
    end
  end

  def self.make_presence_validator(instance, name, **options)
    verbose_name = options[:verbose_name] || name
    error_message = "#{verbose_name.to_s.capitalize} cannot be a nil or empty string"
    condition = value(instance, name).nil? || value(instance, name).empty?

    [error_message, condition]
  end

  def self.make_format_validator(instance, name, pattern, **options)
    verbose_name = options[:verbose_name] || name
    error_message = "Invalid #{verbose_name} format"
    condition = value(instance, name) !~ pattern

    [error_message, condition]
  end

  def self.make_type_validator(instance, name, type, **options)
    verbose_name = options[:verbose_name] || name
    error_message = "#{verbose_name.to_s.capitalize} must be a #{type}"
    condition = !value(instance, name).is_a?(type)

    [error_message, condition]
  end

  def self.make_is_validator(instance, name, predicate, **options)
    verbose_name = options[:verbose_name] || name
    error_message = "#{verbose_name.to_s.capitalize} must be #{predicate}"
    condition = !value(instance, name).send("#{predicate}?")

    [error_message, condition]
  end

  def self.make_comparison_validator(instance, name, operator, other_name, **options)
    verbose_name = options[:verbose_name] || name
    verbose_other_name = options[:verbose_other_name] || other_name
    error_message = "#{verbose_name.to_s.capitalize} and #{verbose_other_name} must be different"
    condition = !value(instance, name).send(operator, value(instance, other_name))

    [error_message, condition]
  end

  def self.make_not_equal_validator(instance, name, other_name, **)
    make_comparison_validator(instance, name, :!=, other_name, **)
  end

  def self.value(instance, name)
    instance.instance_variable_get("@#{name}")
  end
end
