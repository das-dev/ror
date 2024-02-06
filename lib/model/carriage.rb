# frozen_string_literal: true

require_relative '../helpers/manufacturer_info'
require_relative '../helpers/instance_counter'
require_relative '../helpers/validation'
require_relative 'exceptions'

# rubocop disable Style/Documentation
class Carriage
  attr_reader :number

  include ManufacturerInfo
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^[a-zA-Z0-9-]+$/

  def initialize(number)
    @number = number
  end

  def validate!
    raise ValidationError, 'Number can not be empty' if number.empty?
    raise ValidationError, 'Invalid number format' if number !~ NUMBER_FORMAT
  end

  def self.make_carriage(type, *args, **kwargs)
    case type
    when :passenger
      PassengerCarriage.new(*args, **kwargs)
    when :cargo
      CargoCarriage.new(*args, **kwargs)
    else
      raise ArgumentError, "Unknown carriage type: #{type}"
    end
  end

  def titlecase
    to_s.sub(/./, &:upcase)
  end
end
# rubocop enable all

# rubocop disable Style/Documentation
class PassengerCarriage < Carriage
  attr_reader :type, :seats, :occupied_seats

  def initialize(number:, seats: 0)
    super(number)
    @type = :passenger
    @seats = seats
    @occupied_seats = 0
    validate!
  end

  def validate!
    super
    raise ValidationError, 'Total seats must be positive' unless seats.positive?
  end

  def free_seats
    seats - occupied_seats
  end

  def short_titlecase
    "Passenger carriage ##{number}"
  end

  def to_s
    "passenger carriage ##{number}. Free seats: #{free_seats}, occupied seats: #{occupied_seats}"
  end
end
# rubocop enable all

# rubocop disable Style/Documentation
class CargoCarriage < Carriage
  attr_reader :type, :volume, :occupied_volume

  def initialize(number:, volume: 0)
    super(number)
    @type = :cargo
    @volume = volume
    @occupied_volume = 0
    validate!
  end

  def validate!
    super
    raise ValidationError, 'Total volume must be positive' unless volume.positive?
  end

  def free_volume
    volume - occupied_volume
  end

  def short_titlecase
    "Cargo carriage ##{number}"
  end

  def to_s
    "cargo carriage ##{number}. Free volume: #{free_volume}, occupied volume: #{occupied_volume}"
  end
end
# rubocop enable all
