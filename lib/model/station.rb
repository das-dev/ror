# frozen_string_literal: true

require_relative "../helpers/instance_counter"
require_relative "../helpers/validation"

class Station
  include InstanceCounter
  include Validation
  include Enumerable

  attr_reader :name

  validate :name, :presence
  validate :name, :format, /^([a-zA-Z0-9-]{3,}\s*)+$/

  def initialize(name)
    @name = name
    @trains = []
    validate!
  end

  def send_train(train)
    send_train!(train) if train?(train)
  end

  def train_types_stat
    trains.each_with_object(Hash.new(0)) do |train, types|
      types[train.type] += 1
    end
  end

  def each(&)
    trains.each(&)
  end

  def <<(train)
    trains << train unless train?(train)
  end

  def to_s
    "Station \"#{name}\""
  end

  private

  attr_reader :trains

  def send_train!(train)
    # Клиентский код не должен менять список поездов
    # без соблюдения конкретныз условий
    trains.delete(train)
  end

  def train?(train)
    # Клиентскому коду пока не требуется этот метод
    trains.include?(train)
  end
end
