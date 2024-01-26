# frozen_string_literal: true

# rubocop:disable Style/Documentation
class Train
  attr_reader :type, :speed, :carriage_count, :route, :number

  def initialize(number, type, carriage_count)
    @number = number
    @type = type
    @carriage_count = carriage_count
    @speed = 0
    @route = nil
    @current_station_index = 0
  end

  def speed_up(speed)
    @speed += speed
  end

  def speed_down(speed)
    new_speed = @speed - speed
    new_speed = 0 if new_speed.negative?
    @speed = new_speed
  end

  def attach_carriage
    raise CarriageChangedWhileMovingError if @speed.positive?

    @carriage_count += 1
  end

  def detach_carriage
    raise CarriageChangedWhileMovingError if @speed.positive?

    @carriage_count -= 1 if @carriage_count.positive?
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station&.add_train(self)
  end

  def move_forward
    next_station = self.next_station
    raise NoNextStationError unless next_station

    current_station = self.current_station
    return unless current_station

    current_station.send_train(self)
    next_station.add_train(self)
    @current_station_index += 1
  end

  def move_backward
    previous_station = self.previous_station
    raise NoPreviousStationError unless previous_station

    current_station = self.current_station
    return unless current_station

    current_station.send_train(self)
    previous_station.add_train(self)
    @current_station_index -= 1
  end

  def current_station
    return nil if @route.nil? || @current_station_index.negative?

    @route.stations[@current_station_index]
  end

  def previous_station
    return nil if @route.nil? || @current_station_index.zero?

    @route.stations[@current_station_index - 1]
  end

  def next_station
    return nil if @route.nil? || @current_station_index >= @route.stations.size - 1

    @route.stations[@current_station_index + 1]
  end

  class CarriageChangedWhileMovingError < StandardError; end
  class NoNextStationError < StandardError; end
  class NoPreviousStationError < StandardError; end
end
# rubocop:enable all
