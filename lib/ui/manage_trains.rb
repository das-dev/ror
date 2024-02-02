# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ManageTrains
  def initialize(navigation)
    @navigation = navigation
  end

  def make_menu
    manage_trains
    create_train
    list_trains
    show_train
    attach_carriage
    detach_carriage
    assign_route
  end

  private

  attr_reader :navigation

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def manage_trains
    navigation.make('Manage Trains', :manage_trains) do |menu|
      menu.choice('Create train', :create_train, '1')
      menu.choice('List trains', :list_trains, '2')
      menu.choice('Show train', :show_train, '3')
      menu.choice('Attach carriage to train', :add_carriage, '4')
      menu.choice('Detach carriage to train', :remove_carriage, '5')
      menu.choice('Set route to train', :set_route, '6')
      menu.choice('Back to Main Menu', :main_menu, '0')
      menu.choice('Quit', :exit, 'q')
    end
  end

  def create_train
    navigation.bind('Create train form', :create_train, :manage_trains) do
      puts 'Enter train number:'
      number = gets.chomp

      puts 'Choose train type:'
      puts '1. Passenger'
      puts '2. Cargo'
      type = { 1 => :passenger, 2 => :cargo }[gets.chomp.to_i]

      puts 'Enter manufacturer name:'
      manufacturer_name = gets.chomp
      { number:, type:, manufacturer_name: }
    end
  end

  def list_trains
    navigation.bind('List trains:', :list_trains, :manage_trains)
  end

  def show_train
    navigation.bind('Show train:', :show_train, :manage_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp
      { train_index: }
    end
  end

  def attach_carriage
    navigation.bind('Attach carriage to train', :add_carriage, :manage_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp
      puts 'Enter carriage number:'
      carriage_number = gets.chomp
      { train_index:, carriage_number: }
    end
  end

  def detach_carriage
    navigation.bind('Detach carriage to train', :remove_carriage, :manage_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp
      puts 'Enter carriage number:'
      carriage_number = gets.chomp
      { train_index:, carriage_number: }
    end
  end

  def assign_route
    navigation.bind('Set route to train', :set_route, :manage_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Enter train number from list or press Enter:'
      train_index = gets.chomp

      puts navigation.send_action(:list_routes)
      puts 'Enter route number from list or press Enter:'
      route_index = gets.chomp

      { route_index:, train_index: }
    end
  end
end
# rubocop:enable all
