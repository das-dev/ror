# frozen_string_literal: true

require_relative '../helpers/instance_counter'
require_relative '../helpers/validation'
require_relative 'exceptions'

# rubocop:disable Style/Documentation
class Station
  attr_reader :name

  include InstanceCounter
  include Validation
  include Enumerable

  NAME_FORMAT = /^([a-zA-Z0-9-]+\s*)+$/

  def initialize(name)
    @name = name
    @trains = []
    validate!
  end

  def validate!
    raise ValidationError, 'Station name can not be empty' if name.empty?
    raise ValidationError, 'Station name should be at least 3 symbols' if name.length < 3
    raise ValidationError, 'Station has invalid format' if name !~ NAME_FORMAT
  end

  def send_train(train)
    send_train!(train) if train?(train)
  end

  def train_types_stat
    trains.each_with_object(Hash.new(0)) do |train, types|
      types[train.type] += 1
    end
  end

  def each(&block)
    trains.each(&block)
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
# rubocop:enable all
