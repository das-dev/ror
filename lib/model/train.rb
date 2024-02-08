# frozen_string_literal: true

require_relative "../helpers/instance_counter"
require_relative "../helpers/manufacturer_info"
require_relative "../helpers/validation"

# TODO: refactor this class: too many methods
# rubocop:disable Metrics/ClassLength
class Train
  include ManufacturerInfo
  include InstanceCounter
  include Validation
  include Enumerable

  class NoNextStationError < StandardError; end
  class NoPreviousStationError < StandardError; end

  NUMBER_FORMAT = /^[\da-zA-Z]{3}-?[\da-zA-Z]{2}$/

  attr_reader :type, :speed, :route, :number

  def self.make_train(type, number)
    case type
    when :passenger
      PassengerTrain.new(number)
    when :cargo
      CargoTrain.new(number)
    else
      raise ArgumentError, "Unknown train type: #{type}"
    end
  end

  def initialize(number)
    @number = number
    @speed = 0
    @route = nil
    @current_station_index = 0
    @carriages = []
    validate!
  end

  def validate!
    raise ValidationError, "Number can not be empty" if number.empty?
    raise ValidationError, "Number should be at least 3 symbols" if number.length < 3
    raise ValidationError, "Number has invalid format" if number !~ NUMBER_FORMAT
  end

  def assign_route(new_route)
    self.route = new_route
    self.current_station_index = 0
    current_station << self
  end

  def speed_up(speed_diff)
    self.speed += speed_diff
  end

  def speed_down(speed_diff)
    new_speed = speed - speed_diff
    self.speed = new_speed.negative? ? 0 : new_speed
  end

  def detach_carriage(carriage)
    detach_carriage!(carriage) unless speed.positive?
  end

  def move_forward
    raise NoNextStationError unless next_station

    return nil unless current_station

    current_station.send_train(self)
    next_station << self
    self.current_station_index += 1
  end

  def move_backward
    raise NoPreviousStationError unless previous_station

    return nil unless current_station

    current_station.send_train(self)
    previous_station << self
    self.current_station_index -= 1
  end

  def current_station
    current_station! unless current_station_index.negative?
  end

  def previous_station
    previous_station! unless current_station_index.zero?
  end

  def next_station
    next_station! unless current_station_index >= stations_on_current_route.size - 1
  end

  def <<(carriage)
    return nil unless can_attach_carriage?(carriage)

    carriages << carriage
  end

  def [](index)
    carriages[index]
  end

  def each(&)
    carriages.each(&)
  end

  def verbose_type
    raise NotImplementedError
  end

  def description
    "Train ##{number}, #{verbose_type}, #{count} carriages"
  end

  def short_description
    "#{verbose_type.capitalize} train ##{number}"
  end

  def to_s
    short_description
  end

  protected

  # protected потому что нужно вызывать через self
  attr_accessor :current_station_index
  attr_writer :speed, :route

  private

  # приватный т.к. никому не нужен
  attr_reader :carriages

  # приватный т.к. никому для удаления вагонов
  # должны соблюдаться условия
  def detach_carriage!(carriage)
    carriages.delete(carriage)
  end

  def can_attach_carriage?(carriage)
    speed.zero? && carriage.type == type && !carriage?(carriage)
  end

  def carriage?(carriage)
    carriages.include?(carriage)
  end

  # приватный т.к. никому не нужен снаружи
  def stations_on_current_route
    route&.stations || []
  end

  # приватный т.к. нужны доп проверки для использования
  def next_station!
    stations_on_current_route[current_station_index + 1]
  end

  # приватный т.к. нужны доп проверки для использования
  def previous_station!
    stations_on_current_route[current_station_index - 1]
  end

  # приватный т.к. нужны доп проверки для использования
  def current_station!
    stations_on_current_route[current_station_index]
  end
end

class PassengerTrain < Train
  def initialize(number)
    @type = :passenger
    super(number)
  end

  def verbose_type
    "passenger"
  end
end

class CargoTrain < Train
  def initialize(number)
    @type = :cargo
    super(number)
  end

  def verbose_type
    "cargo"
  end
end
# rubocop:enable all
