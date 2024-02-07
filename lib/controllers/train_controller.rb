# frozen_string_literal: true

require_relative '../model/train'
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
    "#{train.titlecase} is created"
  end

  def list_trains
    trains = @storage.get(:trains, []).map.with_index(1) do |train, index|
      "#{index}. #{train.titlecase}"
    end
    trains.empty? ? 'No trains' : trains * "\n"
  end

  def show_train(train_index:)
    train = get_train(train_index)
    train_info(train)
  end

  def assign_route_to_train(route_index:, train_index:)
    route = get_route(route_index.to_i)
    train = get_train(train_index)
    train.assign_route(route)
    "#{train.titlecase} assigned #{route}"
  end

  def find_train_by_number(number:)
    train = get_train_by_number(number)
    raise ControllerError, 'Train not found' unless train

    train_info(train)
  end

  def move_forward(train_index:)
    train = get_train(train_index)
    raise ControllerError, 'Train is not on the route' unless train.route

    begin
      train.move_forward
    rescue Train::NoNextStationError
      raise ControllerError, 'Train is at the end of the route'
    end

    "#{train.titlecase} moved forward"
  end

  def move_backward(train_index:)
    train = get_train(train_index)
    raise ControllerError, 'Train is not on the route' unless train.route

    begin
      train.move_backward
    rescue Train::NoPreviousStationError
      raise ControllerError, 'Train is at the start of the route'
    end

    "#{train.titlecase} moved backward"
  end

  private

  # приватные хелперы

  def try_to_create_train(number, type)
    Train.make_train(type, number)
  rescue ArgumentError, ValidationError => e
    raise ControllerError, "Train is not created: #{e.message}"
  end

  def get_train(train_index)
    train = @storage.get(:trains, [])[train_index.to_i - 1]
    raise ControllerError, "Train ##{train_index} not found" unless train && train_index.to_i.positive?

    train
  end

  def get_train_by_number(number)
    train = @storage.get(:trains, []).find do |t|
      t.number == number
    end
    raise ControllerError, 'Train not found' unless train

    train
  end

  def get_route(route_index)
    route = @storage.get(:routes, [])[route_index - 1]
    raise ControllerError, "Route ##{route_index} not found" unless route && route_index.positive?

    route
  end

  def carriages_info(train)
    carriages = train.map.with_index(1) do |carriage, index|
      "  #{index}. #{carriage.titlecase}"
    end
    carriages.empty? ? 'No carriages' : carriages * "\n"
  end

  def train_info(train)
    on_route = "is on #{train.route}"
    on_factory = "is at the factory #{train.manufacturer_name}"
    route_info = train.route ? on_route : on_factory
    station_info = train.route ? "at #{train.current_station}\n" : ''
    carriages_info = carriages_info(train)

    "#{train.titlecase} #{route_info}\n" \
      "#{station_info}" \
      "#{carriages_info}"
  end
end
# rubocop:enable all
