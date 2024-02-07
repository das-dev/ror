# frozen_string_literal: true

require 'base64'
require 'zlib'

require_relative '../model/route'
require_relative '../model/station'
require_relative '../model/train'

# rubocop:disable Style/Documentation
class ApplicationController
  STAT_VIEW = <<~STAT_VIEW
    Stations: %d
    Cargo carriages: %d
    Passenger carriages: %d
    Cargo trains: %d
    Passenger trains: %d
    Routes: %d
  STAT_VIEW

  def initialize(storage)
    @storage = storage
  end

  def stat
    format(STAT_VIEW,
           fetch_stations_count,
           fetch_cargo_carriages_count,
           fetch_passenger_carriages_count,
           fetch_cargo_trains_count,
           fetch_passenger_trains_count,
           fetch_route_count)
  end

  def about
    content = <<~ABOUT
      eJytUT1vwjAQ3f0rTmGADE4t1DVbV+RKsHQ6GXAhgthSGoQi3Y+vYwfXSZBY
      +qTk3n28l4sNMAXy0oFjiCnzHJN0KLGJwWrm+QqYpx5SOgcOu0ZVBjbKqJOu
      tWlhW9W3q2pt45pz5OkeAmCFLm7UUcO+g61uTrqDD113ymhzsfDtbNqzht25
      Mhej2+qgRntY4YN3GeNgb82PLl7+io21pT84Pj/AkGIs8uN9z8tlcCjsE/vx
      tx7wgmLIn/SHOsUOJQOsv7IcidA9UZMMh3mKRuSV/bx/MQgXvhbrd3rIaKpH
      /ApqIZwB/W2JxN64lNxByiwrs547FkjAOJ1nnwwW/wH2Cxl/p/o=
    ABOUT
    Zlib::Inflate.inflate(Base64.decode64(content))
  end

  private

  def fetch_stations_count
    @storage[:stations].size
  end

  def fetch_route_count
    @storage[:routes].size
  end

  def fetch_cargo_carriages_count
    @storage[:carriages].select { |t| t.type == :cargo }.size
  end

  def fetch_passenger_carriages_count
    @storage[:carriages].select { |t| t.type == :passenger }.size
  end

  def fetch_cargo_trains_count
    @storage[:trains].select { |t| t.type == :cargo }.size
  end

  def fetch_passenger_trains_count
    @storage[:trains].select { |t| t.type == :passenger }.size
  end
end
# rubocop:enable all
