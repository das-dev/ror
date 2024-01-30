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

  def attach_carriage(train_index:, carriage_number:)
    train = get_train(train_index.to_i)

    return 'Train not found' unless train

    carriage = Carriage.new(train.type, carriage_number)
    train.attach_carriage(carriage)
    "Carriage ##{carriage_number} is attached to #{train}"
  end

  def detach_carriage(train_index:, carriage_number:)
    train = get_train(train_index.to_i)

    return 'Train not found' unless train

    train.detach_carriage_by_number(carriage_number)
    "Carriage ##{carriage_number} is detached from #{train}"
  end

  def assign_route_to_train(route_index:, train_index:)
    route = get_route(route_index.to_i)
    train = get_train(train_index.to_i)

    return 'Route not found' unless route
    return 'Train not found' unless train

    train.assign_route(route)
    "#{train.to_s.capitalize} assigned #{route}"
  end

  def move_forward(train_index:)
    train = get_train(train_index.to_i)

    return 'Train not found' unless train

    train.move_forward
    "#{train.to_s.capitalize} moved forward"
  end

  def move_backward(train_index:)
    train = get_train(train_index.to_i)

    return 'Train not found' unless train

    train.move_backward
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
