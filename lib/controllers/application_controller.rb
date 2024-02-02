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
    "Stations: #{Station.instances}\n" \
      "Cargo trains: #{CargoTrain.instances}\n" \
      "Passenger trains: #{PassengerTrain.instances}\n" \
      "Routes: #{Route.instances}"
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
