# frozen_string_literal: true

# rubocop:disable Style/Documentation
class Train
  attr_reader :type, :speed, :route, :number

  def initialize(number)
    @number = number
    @speed = 0
    @route = nil
    @current_station_index = 0
    @carriages = []
  end

  def carriage_count
    carriages.size
  end

  def assign_route(new_route)
    self.route = new_route
    self.current_station_index = 0
    current_station.add_train(self)
  end

  def speed_up(speed_diff)
    self.speed += speed_diff
  end

  def speed_down(speed_diff)
    new_speed = speed - speed_diff
    self.speed = new_speed.negative? ? 0 : new_speed
  end

  def attach_carriage(carriage)
    return nil if speed.positive? || carriage.type != type

    carriages << carriage
    carriage
  end

  def detach_carriage_by_number(carriage_number)
    detach_carriage_by_number!(carriage_number) unless speed.positive?
  end

  def move_forward
    raise NoNextStationError unless next_station

    return unless current_station

    current_station.send_train(self)
    next_station.add_train(self)
    self.current_station_index += 1
  end

  def move_backward
    raise NoPreviousStationError unless previous_station

    return unless current_station

    current_station.send_train(self)
    previous_station.add_train(self)
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

  private

  attr_reader :carriages

  def detach_carriage_by_number!(carriage_number)
    carriages.delete_if { |carriage| carriage.number == carriage_number }
  end

  def stations_on_current_route
    route&.stations || []
  end

  def next_station!
    stations_on_current_route[current_station_index + 1]
  end

  def previous_station!
    stations_on_current_route[current_station_index - 1]
  end

  def current_station!
    stations_on_current_route[current_station_index]
  end

  protected

  attr_accessor :current_station_index
  attr_writer :speed, :route

  class NoNextStationError < StandardError; end
  class NoPreviousStationError < StandardError; end
end

class PassengerTrain < Train
  def initialize(number)
    @type = :passenger
    super(number)
  end
end

class CargoTrain < Train
  def initialize(number)
    @type = :cargo
    super(number)
  end
end
# rubocop:enable all
