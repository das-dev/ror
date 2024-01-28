# frozen_string_literal: true

require_relative '../model/station'

# rubocop:disable Style/Documentation
class StationController
  def initialize(storage)
    @storage = storage
  end

  def create_station
    puts 'Enter station name:'
    name = gets.chomp
    station = Station.new(name)
    @storage.add_to_list(:stations, station)
    puts "Station #{station.name} created"
    station
  end

  def list_station
    puts 'Stations:'
    @storage.get(:stations, []).each_with_index do |station, index|
      puts "#{index + 1}. #{station.name}"
    end
  end
end
# rubocop:enable all
