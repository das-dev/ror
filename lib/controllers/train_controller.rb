# frozen_string_literal: true

require_relative '../model/train'
require_relative '../model/carriage'

# rubocop:disable Style/Documentation
class TrainController
  def initialize(storage)
    @storage = storage
  end

  def create_train(number:, type:)
    train = Train.make_train(number, type)
    @storage.add_to_list(:trains, train)
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
    return 'Train not found' unless train

    route_info = train.route ? "is on #{train.route}" : 'is at the factory'
    station_info = train.route ? "at #{train.current_station}\n" : ''
    carriages_info = "with #{train.carriage_count} carriages"

    "#{train.to_s.capitalize} #{route_info}\n" \
      "#{station_info}" \
      "#{carriages_info}"
  end

  def attach_carriage(train_index:, carriage_number:)
    train = get_train(train_index.to_i)
    return 'Train not found' unless train

    carriage = Carriage.new(train.type, carriage_number)
    return 'Carriage not attached' unless train.attach_carriage(carriage)

    "Carriage ##{carriage_number} is attached to #{train}"
  end

  def detach_carriage(train_index:, carriage_number:)
    train = get_train(train_index.to_i)
    return 'Train not found' unless train

    carriage = train.detach_carriage_by_number(carriage_number)
    return 'Carriage not detached' unless carriage

    "Carriage ##{carriage_number} is detached from #{train}"
  end

  def assign_route_to_train(route_index:, train_index:)
    route = get_route(route_index.to_i)
    return 'Route not found' unless route

    train = get_train(train_index.to_i)
    return 'Train not found' unless train

    train.assign_route(route)
    "#{train.to_s.capitalize} assigned #{route}"
  end

  def move_forward(train_index:)
    train = get_train(train_index.to_i)
    return 'Train not found' unless train
    return 'Train is not on the route' unless train.route

    begin
      train.move_forward
    rescue Train::NoNextStationError
      return 'Train is at the end of the route'
    end

    "#{train.to_s.capitalize} moved forward"
  end

  def move_backward(train_index:)
    train = get_train(train_index.to_i)
    return 'Train not found' unless train
    return 'Train is not on the route' unless train.route

    begin
      train.move_backward
    rescue Train::NoPreviousStationError
      return 'Train is at the start of the route'
    end

    "#{train.to_s.capitalize} moved backward"
  end

  private

  def get_train(train_index)
    train = @storage.get(:trains, [])[train_index.to_i - 1]
    train_index.positive? && train
  end

  def get_route(route_index)
    route = @storage.get(:routes, [])[route_index.to_i - 1]
    route_index.positive? && route
  end
end
# rubocop:enable all
