# frozen_string_literal: true

module Exceptions
  class CarriageChangedWhileMovingError < StandardError; end
  class NoNextStationError < StandardError; end
end

# rubocop:disable Style/Documentation
class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    return nil if train?(train)

    @trains << train
  end

  def send_train(train)
    return nil unless train?(train)

    @trains.delete(train)
  end

  def types_trains
    @trains.each_with_object(Hash.new(0)) do |train, types|
      types[train.type] += 1
    end
  end

  private

  def train?(train)
    @trains.include?(train)
  end
end

class Route
  attr_reader :origin_station, :destination_station

  def initialize(origin_station, destination_station)
    @origin_station = origin_station
    @destination_station = destination_station
    @intermediate_stations = []
  end

  def append_intermediate_station(station)
    return nil if intermediate_station?(station)

    @intermediate_stations << station
  end

  def remove_intermediate_station(station)
    return nil unless intermediate_station?(station)

    @intermediate_stations.delete(station)
  end

  def stations
    [@origin_station, *@intermediate_stations, @destination_station]
  end

  private

  def intermediate_station?(station)
    @intermediate_stations.include?(station)
  end
end

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
    @carriage_count += 1 if @speed.zero?
  end

  def detach_carriage
    @carriage_count -= 1 if @speed.zero? && @carriage_count.positive?
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station&.add_train(self)
  end

  def move_forward
    next_station = self.next_station
    current_station = self.current_station
    return unless next_station && current_station

    current_station.send_train(self)
    next_station.add_train(self)
    @current_station_index += 1
  end

  def move_backward
    current_station = self.current_station
    previous_station = self.previous_station
    return unless previous_station && current_station

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
end
# rubocop:enable Style/Documentation
