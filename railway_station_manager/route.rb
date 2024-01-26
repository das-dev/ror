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
# rubocop:enable all
