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
    puts "#{station.to_s.capitalize} is created"
    puts ''
    station
  end

  def list_stations
    puts 'Stations:'
    @storage.get(:stations, []).each.with_index(1) do |station, index|
      puts "#{index}. #{station.to_s.capitalize}"
    end.empty? && puts('No stations')
    puts ''
  end

  def select_station
    list_stations
    puts 'Enter # station or press Enter to return to stations menu:'
    event = gets.chomp
    @storage.get(:stations, [])[event.to_i - 1]
  end

  def list_trains_on_station
    station = select_station
    return nil if station.nil?

    station.trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.to_s.capitalize}"
    end.empty? && puts('No trains')
  end
end
# rubocop:enable all
