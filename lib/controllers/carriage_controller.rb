# frozen_string_literal: true

require_relative "../model/carriage"
require_relative "exceptions"

class CarriageController
  def initialize(storage)
    @storage = storage
  end

  def create_carriage(number:, type:, manufacturer_name:, extra_params: {})
    carriage = try_to_create_carriage(type, number, manufacturer_name, extra_params)
    check_carriage_existence(carriage)
    @storage.add_to_list(:carriages, carriage)

    "#{carriage} is created"
  end

  def list_carriages
    carriages = @storage.get(:carriages, []).map.with_index(1) do |carriage, index|
      "#{index}. #{carriage.description}"
    end
    carriages.empty? ? "No carriages" : carriages * "\n"
  end

  def list_carriages_in_train(train_index:)
    train = get_train(train_index)
    carriages = train.map.with_index(1) do |carriage, index|
      "#{index}. #{carriage.description}"
    end

    carriage_list = carriages.empty? ? "No carriages in train" : carriages * "\n"
    "Carriages in #{train.verbose_type} train ##{train.number}:\n#{carriage_list}"
  end

  def attach_carriage(train_index:, carriage_index:)
    train = get_train(train_index)
    carriage = get_carriage(carriage_index)

    raise ControllerError, "Carriage not attached" unless train << carriage

    "Carriage ##{carriage.number} is attached to #{train.verbose_type} train ##{train.number}"
  end

  def detach_carriage(train_index:, carriage_index:)
    train = get_train(train_index)
    carriage = get_carriage_in_train(train, carriage_index)
    carriage = train.detach_carriage(carriage)
    raise ControllerError, "Carriage not detached" unless carriage

    "Carriage ##{carriage.number} is detached from #{train}"
  end

  def occupy_carriage_seat(train_index:, carriage_index:)
    train = get_train(train_index)
    carriage = get_carriage_in_train(train, carriage_index)
    raise ControllerError, "Carriage is not a passenger one" unless carriage.passenger?

    carriage.occupy_seat
    "Seat in carriage ##{carriage.number} is occupied"
  end

  def occupy_carriage_volume(train_index:, carriage_index:, volume:)
    train = get_train(train_index)
    carriage = get_carriage_in_train(train, carriage_index)
    raise ControllerError, "Carriage is not a cargo one" unless carriage.cargo?

    carriage.occupy_volume(volume.to_i)
    "Volume in carriage ##{carriage.number} is occupied"
  end

  private

  # приватные хелперы

  def try_to_create_carriage(type, carriage_number, manufacturer_name, raw_extra_params)
    extra_params = process_extra_params(type, **raw_extra_params)
    carriage = Carriage.make_carriage(type, number: carriage_number, **extra_params)
    carriage.manufacturer_name = manufacturer_name
    carriage
  rescue Validation::ValidationError => e
    raise ControllerError, "Carriage is not created: #{e.message}"
  end

  def check_carriage_existence(carriage)
    already_exists = @storage.get(:carriages, []).any? { |c| c == carriage }
    raise ControllerError, "#{carriage.short_description} already exists" if already_exists
  end

  def get_carriage(carriage_index)
    carriage = @storage.get(:carriages, [])[carriage_index.to_i - 1]
    unless carriage && carriage_index.to_i.positive?
      raise ControllerError, "Carriage ##{carriage_index} not found"
    end

    carriage
  end

  def get_carriage_in_train(train, carriage_index)
    carriage = train[carriage_index.to_i - 1]
    unless carriage && carriage_index.to_i.positive?
      raise ControllerError, "Carriage ##{carriage_index} not found"
    end

    carriage
  end

  def get_train(train_index)
    train = @storage.get(:trains, [])[train_index.to_i - 1]
    unless train && train_index.to_i.positive?
      raise ControllerError, "Train ##{train_index} not found"
    end

    train
  end

  def process_extra_params(type, seats: nil, volume: nil)
    case type
    when :passenger
      { seats: seats.to_i } if seats
    when :cargo
      { volume: volume.to_i } if volume
    when nil
      raise ControllerError, "Carriage type is not specified"
    else
      raise ControllerError, "Unknown carriage type: #{type}"
    end
  end
end
