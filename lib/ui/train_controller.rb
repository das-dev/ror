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
    train = Train.new(number)
    @storage.add(:trains, train)
    puts "Train #{train.number} created"
  end

  def list_trains
    puts 'Trains:'
    @storage.get(:trains, []).each_with_index do |train, index|
      puts "#{index + 1}. #{train.number}"
    end
  end
end
# rubocop:enable all
