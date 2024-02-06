# frozen_string_literal: true

require_relative '../model/carriage'
require_relative 'exceptions'

# rubocop:disable Style/Documentation
class CarriageController
  def initialize(storage)
    @storage = storage
  end

  def create_carriage(number:, type:, manufacturer_name:)
    carriage = try_to_create_carriage(number, type)
    @storage.add_to_list(:carriages, carriage)
    carriage.manufacturer_name = manufacturer_name
    "#{carriage.titlecase} is created"
  end

  def list_carriages
    carriages = @storage.get(:carriages, []).map.with_index(1) do |carriage, index|
      "#{index}. #{carriage.titlecase}"
    end
    carriages.empty? ? 'No carriages' : carriages.join("\n")
  end

  def list_carriages_in_train(train_index:)
    train = get_train(train_index)
    carriages = train.map.with_index(1) do |c, index|
      "#{index}. #{c.titlecase}"
    end

    carriages.empty? ? 'No carriages in train' : carriages.join("\n")
  end

  def attach_carriage(train_index:, carriage_index:)
    train = get_train(train_index)
    carriage = get_carriage(carriage_index)

    raise ControllerError, 'Carriage not attached' unless train << carriage

    "Carriage ##{carriage.number} is attached to #{train}"
  end

  def detach_carriage(train_index:, carriage_index:)
    train = get_train(train_index)
    carriage = get_carriage_in_train(train, carriage_index)
    carriage = train.detach_carriage(carriage)
    raise ControllerError, 'Carriage not detached' unless carriage

    "Carriage ##{carriage.number} is detached from #{train}"
  end

  private

  # приватные хелперы

  def try_to_create_carriage(carriage_number, type)
    Carriage.make_carriage(type, number: carriage_number)
  rescue ValidationError => e
    raise ControllerError, "Carriage is not created: #{e.message}"
  end

  def get_carriage(carriage_index)
    carriage = @storage.get(:carriages, [])[carriage_index.to_i - 1]
    raise ControllerError, "Carriage ##{carriage_index} not found" unless carriage && carriage_index.to_i.positive?

    carriage
  end

  def get_carriage_in_train(train, carriage_index)
    carriage = train[carriage_index.to_i - 1]
    raise ControllerError, "Carriage ##{carriage_index} not found" unless carriage && carriage_index.to_i.positive?

    carriage
  end

  def get_train(train_index)
    train = @storage.get(:trains, [])[train_index.to_i - 1]
    raise ControllerError, "Train ##{train_index} not found" unless train && train_index.to_i.positive?

    train
  end
end
# rubocop:enable all
