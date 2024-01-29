# frozen_string_literal: true

require_relative '../model/train'
require_relative '../model/carriage'

# rubocop:disable Style/Documentation
class TrainController
  def initialize(storage)
    @storage = storage
  end

  def create_train
    puts 'Enter train number:'
    number = gets.chomp
    puts 'Choose train type:'
    puts '1. Passenger'
    puts '2. Cargo'
    type = { 1 => :passenger, 2 => :cargo }[gets.chomp.to_i]
    train = Train.make_train(number, type)
    @storage.add_to_list(:trains, train)
    puts "#{train.to_s.capitalize} is created"
  end

  def list_trains
    puts 'Trains:'
    @storage.get(:trains, []).each.with_index(1) do |train, index|
      puts "#{index}. #{train.to_s.capitalize}"
    end.empty? && puts('No trains')
  end

  def choose_train
    list_trains
    puts 'Choose train:'
    @storage.get(:trains, [])[gets.chomp.to_i - 1]
  end

  def attach_carriage_to_train
    train = choose_train
    puts 'Enter carriage number:'
    carriage_number = gets.chomp
    carriage = Carriage.new(train.type, carriage_number)
    train.attach_carriage(carriage)
    puts "Carriage ##{carriage_number} is attached to #{train}"
  end

  def detach_carriage_from_train
    train = choose_train
    puts 'Enter carriage number:'
    carriage_number = gets.chomp
    train.detach_carriage_by_number(carriage_number)
    puts "Carriage ##{carriage_number} is detached from #{train}"
  end

  def move_train_backward_on_route
    train = choose_train
    train.move_backward
    puts "#{train.to_s.capitalize} moved backward"
  end

  def move_train_forward_on_route
    train = choose_train
    train.move_forward
    puts "#{train.to_s.capitalize} moved forward"
  end
end
# rubocop:enable all
