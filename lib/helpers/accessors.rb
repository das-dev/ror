# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      attr_reader name, "#{name}_history"

      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value)
        history = instance_variable_get("@#{name}_history") || []
        instance_variable_set("@#{name}_history", history << value)
      end
    end
  end

  def strong_attr_accessor(name, type)
    attr_reader name

    define_method("#{name}=") do |value|
      raise TypeError, "Invalid type" unless value.is_a?(type)

      instance_variable_set("@#{name}", value)
    end
  end
end
