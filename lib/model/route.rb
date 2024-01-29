# frozen_string_literal: true

# rubocop:disable Style/Documentation
class Route
  attr_reader :origin_station, :destination_station

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

  attr_reader :intermediate_stations

  def intermediate_station?(station)
    intermediate_stations.include?(station)
  end

  def append_station!(station)
    intermediate_stations << station
  end

  def remove_station!(station)
    intermediate_stations.delete(station)
  end
end
# rubocop:enable all
