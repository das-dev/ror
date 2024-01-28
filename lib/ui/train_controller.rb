# frozen_string_literal: true

require_relative '../model/train'

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
    @storage.add(:trains, train)
    puts "#{train} created"
  end

  def list_trains
    puts 'Trains:'
    @storage.get(:trains, []).each_with_index do |train, index|
      puts "#{index + 1}. #{train}"
    end
  end
end
# rubocop:enable all
