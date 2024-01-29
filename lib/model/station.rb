# frozen_string_literal: true

# rubocop:disable Style/Documentation
class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    add_train!(train) unless train?(train)
  end

  def send_train(train)
    send_train!(train) if train?(train)
  end

  def train_types_stat
    trains.each_with_object(Hash.new(0)) do |train, types|
      types[train.type] += 1
    end
  end

  def to_s
    "station \"#{name}\""
  end

  private

  def send_train!(train)
    # Клиентский код не должен менять список поездов
    # без соблюдения конкретныз условий
    trains.delete(train)
  end

  def add_train!(train)
    # Клиентский код не должен менять список поездов
    # без соблюдения конкретныз условий
    trains << train
  end

  def train?(train)
    # Клиентскому коду пока не требуется этот метод
    trains.include?(train)
  end
end
# rubocop:enable all
