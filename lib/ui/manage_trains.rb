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
    attach_carriage
    detach_carriage
    assign_route

    move_trains
    move_forward
    move_backward
  end

  private

  attr_reader :train_controller, :route_controller, :navigation

  def manage_trains
    navigation.make('Manage Trains', :manage_trains) do |menu|
      menu.choice('Create train', :create_train, '1')
      menu.choice('List trains', :list_trains, '2')
      menu.choice('Attach carriage to train', :attach_carriage, '3')
      menu.choice('Detach carriage to train', :detach_carriage, '4')
      menu.choice('Set route to train', :assign_route, '5')
      menu.choice 'Back to Main Menu', :main_menu, '0'
    end
  end

  def move_trains
    navigation.make('Move Trains', :move_trains) do |menu|
      menu.choice('Move train forward on route', :move_forward, '1')
      menu.choice('Move train backward on route', :move_backward, '2')
      menu.choice 'Back to Main Menu', :main_menu, '0'
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
      { number:, type: }
    end
  end

  def list_trains
    navigation.bind('List trains:', :list_trains, :manage_trains)
  end

  def attach_carriage
    navigation.bind('Attach carriage to train', :attach_carriage, :manage_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp.to_i
      puts 'Enter carriage number:'
      carriage_number = gets.chomp
      { train_index:, carriage_number: }
    end
  end

  def detach_carriage
    navigation.bind('Detach carriage to train', :detach_carriage, :manage_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp.to_i
      puts 'Enter carriage number:'
      carriage_number = gets.chomp
      { train_index:, carriage_number: }
    end
  end

  def assign_route
    navigation.bind('Set route to train', :assign_route, :manage_routes) do
      puts navigation.send_action(:list_routes)
      puts 'Enter route number:'
      route_index = gets.chomp

      puts navigation.send_action(:list_trains)
      puts 'Enter train number:'
      train_index = gets.chomp

      { route_index:, train_index: }
    end
  end

  def move_forward
    navigation.bind('Move train forward on route', :move_forward, :manage_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp.to_i
      { train_index: }
    end
  end

  def move_backward
    navigation.bind('Move train backward on route', :move_backward, :manage_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp.to_i
      { train_index: }
    end
  end
end
# rubocop:enable all
