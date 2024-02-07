# frozen_string_literal: true

# rubocop:disable Style/Documentation
module ManufacturerInfo
  attr_reader :manufacturer_name

  NAME_FORMAT = /^[a-zA-Z0-9\- ]+$/

  def manufacturer_name=(name)
    raise ValidationError, 'Manufacturer name can not be empty' if name.empty?
    raise ValidationError, 'Manufacturer name should be at least 3 symbols' if name.length < 3
    raise ValidationError, 'Manufacturer name has invalid format' if name !~ NAME_FORMAT

    @manufacturer_name = name
  end
end
# rubocop:enable all
