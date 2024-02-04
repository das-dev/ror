# frozen_string_literal: true

require_relative '../model/train'
require_relative '../model/carriage'
require_relative 'exceptions'

# rubocop:disable Style/Documentation
class TrainController
  def initialize(storage)
    @storage = storage
  end

  def create_train(number:, type:, manufacturer_name:)
    train = try_to_create_train(number, type)
    @storage.add_to_list(:trains, train)
    train.manufacturer_name = manufacturer_name
    "#{train.to_s.capitalize} is created"
  end

  def list_trains
    trains = @storage.get(:trains, []).map.with_index(1) do |train, index|
      "#{index}. #{train.to_s.capitalize}"
    end
    trains.empty? ? 'No trains' : trains.join("\n")
  end

  def show_train(train_index:)
    train = get_train(train_index.to_i)
    train_info(train)
  end

  def attach_carriage(train_index:, carriage_number:)
    train = get_train(train_index.to_i)
    carriage = try_to_create_carriage(train, carriage_number)
    raise ControllerError, 'Carriage not attached' unless train.attach_carriage(carriage)

    "Carriage ##{carriage_number} is attached to #{train}"
  end

  def detach_carriage(train_index:, carriage_number:)
    train = get_train(train_index.to_i)
    carriage = train.detach_carriage_by_number(carriage_number)
    raise ControllerError, 'Carriage not detached' unless carriage

    "Carriage ##{carriage_number} is detached from #{train}"
  end

  def assign_route_to_train(route_index:, train_index:)
    route = get_route(route_index.to_i)
    train = get_train(train_index.to_i)
    train.assign_route(route)
    "#{train.to_s.capitalize} assigned #{route}"
  end

  def find_train_by_number(number:)
    train = get_train_by_number(number)
    raise ControllerError, 'Train not found' unless train

    train_info(train)
  end

  def move_forward(train_index:)
    train = get_train(train_index.to_i)
    raise ControllerError, 'Train is not on the route' unless train.route

    begin
      train.move_forward
    rescue Train::NoNextStationError
      raise ControllerError, 'Train is at the end of the route'
    end

    "#{train.to_s.capitalize} moved forward"
  end

  def move_backward(train_index:)
    train = get_train(train_index.to_i)
    raise ControllerError, 'Train is not on the route' unless train.route

    begin
      train.move_backward
    rescue Train::NoPreviousStationError
      raise ControllerError, 'Train is at the start of the route'
    end

    "#{train.to_s.capitalize} moved backward"
  end

  private

  # приватные хелперы

  def try_to_create_carriage(type, carriage_number)
    Carriage.new(type, carriage_number)
  rescue RuntimeError => e
    raise ControllerError, "Carriage is not created: #{e.message}"
  end

  def try_to_create_train(number, type)
    Train.make_train(number, type)
  rescue RuntimeError => e
    raise ControllerError, "Train is not created: #{e.message}"
  end

  def get_train(train_index)
    train = @storage.get(:trains, [])[train_index.to_i - 1]
    train_index.positive? && train
    raise ControllerError, "Train ##{train_index} not found" unless train && train_index.positive?

    train
  end

  def get_train_by_number(number)
    train = @storage.get(:trains, []).find do |t|
      t.number == number
    end
    raise ControllerError, 'Train not found' unless train
  end

  def get_route(route_index)
    route = @storage.get(:routes, [])[route_index - 1]
    raise ControllerError, "Route ##{route_index} not found" unless route && route_index.positive?

    route
  end

  def train_info(train)
    on_route = "is on #{train.route}"
    on_factory = "is at the factory #{train.manufacturer_name}"
    route_info = train.route ? on_route : on_factory
    station_info = train.route ? "at #{train.current_station}\n" : ''
    carriages_info = "with #{train.carriage_count} carriages"

    "#{train.to_s.capitalize} #{route_info}\n" \
      "#{station_info}" \
      "#{carriages_info}"
  end
end
# rubocop:enable all
