# frozen_string_literal: true

require_relative '../helpers/instance_counter'

# rubocop:disable Style/Documentation
class Route
  attr_reader :origin_station, :destination_station

  include InstanceCounter

  def initialize(origin_station, destination_station)
    @origin_station = origin_station
    @destination_station = destination_station
    @intermediate_stations = []
  end

  def append_intermediate_station(station)
    append_station!(station) unless intermediate_station?(station)
  end

  def remove_intermediate_station(station)
    remove_station!(station) if intermediate_station?(station)
  end

  def stations
    [origin_station, *intermediate_stations, destination_station]
  end

  def to_s
    route = stations.map(&:name).join(' -> ')
    "route: #{route}"
  end

  private

  # приватный т.к. никому не нужен
  attr_reader :intermediate_stations

  # приватный т.к. никому не нужен
  def intermediate_station?(station)
    intermediate_stations.include?(station)
  end

  # приватный т.к. для добавления станции в маршрут
  # нужно соблюдать определенные условия
  def append_station!(station)
    intermediate_stations << station
  end

  # приватный т.к. для ужаления станции из маршрута
  # нужно соблюдать определенные условия
  def remove_station!(station)
    intermediate_stations.delete(station)
  end
end
# rubocop:enable all
