# frozen_string_literal: true

# rubocop:disable all
module Forms
  def enter_carriage_number
    puts 'Enter carriage number:'
    gets.chomp
  end

  def enter_carriage_extra_params(type)
    case type
    when :passenger
      puts 'Enter total seats:'
      { seats: gets.chomp }
    when :cargo
      puts 'Enter total volume:'
      { volume: gets.chomp }
    else
      {}
    end
  end

  def choose_carriage_type
    puts 'Choose carriage type:'
    puts '1. Passenger'
    puts '2. Cargo'
    { 1 => :passenger, 2 => :cargo }[gets.chomp.to_i]
  end

  def choose_train_type
    puts 'Choose carriage type:'
    puts '1. Passenger'
    puts '2. Cargo'
    { 1 => :passenger, 2 => :cargo }[gets.chomp.to_i]
  end

  def enter_manufacturer_name
    puts 'Enter manufacturer name:'
    gets.chomp
  end

  def enter_station_name
    puts 'Enter station name:'
    gets.chomp
  end

  def enter_train_number
    puts 'Enter train number:'
    gets.chomp
  end

  def enter_occupied_volume
    puts 'Occupy volume:'
    gets.chomp
  end

  def choose_train
    puts 'Choose train:'
    gets.chomp
  end

  def choose_carriage
    puts 'Choose carriage:'
    gets.chomp
  end

  def choose_origin_station
    puts 'Choose origin station:'
    gets.chomp
  end

  def choose_destination_station
    puts 'Choose destination station:'
    gets.chomp
  end

  def choose_route
    puts 'Choose route:'
    gets.chomp
  end

  def choose_station
    puts 'Choose station:'
    gets.chomp
  end
end
# rubocop:enable all
