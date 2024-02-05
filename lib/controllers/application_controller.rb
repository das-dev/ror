# frozen_string_literal: true

require 'base64'
require 'zlib'

require_relative '../model/station'
require_relative '../model/train'
require_relative '../model/route'

# rubocop:disable Style/Documentation
class ApplicationController
  def initialize(storage)
    @storage = storage
  end

  def stat
    route_count = @storage.get(:routes, []).size
    station_count = @storage.get(:stations, []).size
    cargo_train_count = @storage.get(:trains, []).select { |t| t.type == :cargo }.size
    passenger_train_count = @storage.get(:trains, []).select { |t| t.type == :passenger }.size
    cargo_carriage_count = @storage.get(:carriages, []).select { |c| c.type == :cargo }.size
    passenger_carriage_count = @storage.get(:carriages, []).select { |c| c.type == :passenger }.size

    "Stations: #{station_count}\n" \
      "Cargo trains: #{cargo_train_count}\n" \
      "Passenger trains: #{passenger_train_count}\n" \
      "Cargo carriages: #{cargo_carriage_count}\n" \
      "Passenger carriages: #{passenger_carriage_count}\n" \
      "Routes: #{route_count}"
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
end
# rubocop:enable all
