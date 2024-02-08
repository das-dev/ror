# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def new(*args, **kwargs, &)
      obj = super
      register_instance
      obj
    end

    def instances
      @instances ||= 0
    end

    private

    attr_writer :instances

    def register_instance
      self.instances += 1
    end
  end
end
