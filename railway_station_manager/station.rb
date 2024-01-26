# frozen_string_literal: true

# rubocop:disable Style/Documentation
class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    return nil if train?(train)

    @trains << train
  end

  def send_train(train)
    return nil unless train?(train)

    @trains.delete(train)
  end

  def train_types_stat
    @trains.each_with_object(Hash.new(0)) do |train, types|
      types[train.type] += 1
    end
  end

  private

  def train?(train)
    @trains.include?(train)
  end
end
# rubocop:enable all
