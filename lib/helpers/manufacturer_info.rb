# frozen_string_literal: true

module ManufacturerInfo
  NAME_FORMAT = /^[a-zA-Z0-9\- ]+$/

  attr_reader :manufacturer_name

  def manufacturer_name=(name)
    raise Validation::ValidationError, "Manufacturer name can not be empty" if name.empty?
    raise Validation::ValidationError, "Manufacturer name should be at least 3 symbols" if name.length < 3
    raise Validation::ValidationError, "Manufacturer name has invalid format" if name !~ NAME_FORMAT

    @manufacturer_name = name
  end
end
