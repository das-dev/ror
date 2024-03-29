# frozen_string_literal: true

require_relative "../helpers/instance_counter"
require_relative "../helpers/manufacturer_info"
require_relative "../helpers/validation"

class Carriage
  include ManufacturerInfo
  include InstanceCounter
  include Validation

  attr_reader :number

  NUMBER_FORMAT = /^[a-zA-Z0-9-]+$/

  def self.make_carriage(type, *, **)
    case type
    when :passenger
      PassengerCarriage.new(*, **)
    when :cargo
      CargoCarriage.new(*, **)
    else
      raise ArgumentError, "Unknown carriage type: #{type}"
    end
  end

  def initialize(number)
    @number = number
  end

  def ==(other)
    number == other.number && type == other.type
  end

  def to_s
    short_description
  end

  def short_description
    "#{verbose_type.capitalize} carriage ##{number}"
  end

  def verbose_type
    raise NotImplementedError
  end

  def cargo?
    type == :cargo
  end

  def passenger?
    type == :passenger
  end
end

class PassengerCarriage < Carriage
  attr_reader :type, :seats, :occupied_seats

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :seats, :is, :positive, verbose_name: "total seats number"

  def initialize(number:, seats: 0)
    super(number)
    @type = :passenger
    @seats = seats
    @occupied_seats = 0
    validate!
  end

  def free_seats
    seats - occupied_seats
  end

  def occupy_seat
    raise ValidationError, "No free seats" if free_seats.zero?

    self.occupied_seats += 1
  end

  def verbose_type
    "passenger"
  end

  def description
    "Carriage ##{number}, #{verbose_type}, #{free_seats} " \
      "free seats, #{occupied_seats} occupied seats"
  end

  private

  attr_writer :occupied_seats
end

class CargoCarriage < Carriage
  attr_reader :type, :volume, :occupied_volume

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :volume, :is, :positive, verbose_name: "total volume value"

  def initialize(number:, volume: 0)
    super(number)
    @type = :cargo
    @volume = volume
    @occupied_volume = 0
    validate!
  end

  def free_volume
    volume - occupied_volume
  end

  def occupy_volume(amount)
    raise ValidationError, "No free volume" if free_volume < amount

    self.occupied_volume += amount
  end

  def verbose_type
    "cargo"
  end

  def description
    "Carriage ##{number}, #{verbose_type}, #{free_volume} " \
      "free volume, #{occupied_volume} occupied volume"
  end

  private

  attr_writer :occupied_volume
end
