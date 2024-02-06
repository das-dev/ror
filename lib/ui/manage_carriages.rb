# frozen_string_literal: true

require_relative 'menu'

# rubocop:disable Style/Documentation
class ManageCarriages < Menu
  def make_menu
    manage_carriages
    create_carriage
    list_carriages
    list_carriages_in_train
    attach_carriage
    detach_carriage
  end

  private

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def manage_carriages
    navigation.make('Manage Carriages', :manage_carriages) do |menu|
      menu.choice('Create carriage', :create_carriage, '1')
      menu.choice('List carriages', :list_carriages, '2')
      menu.choice('List carriages in train', :list_carriages_in_train, '3')
      menu.choice('Attach carriage to train', :add_carriage, '4')
      menu.choice('Detach carriage from train', :remove_carriage, '5')
      menu.choice('Back to Main Menu', :main_menu, '0')
      menu.choice('Quit', :exit, 'q')
    end
  end

  def create_carriage
    navigation.bind('Create carriage form', :create_carriage, :manage_carriages, attempts: 3) do
      puts 'Enter carriage number:'
      number = gets.chomp

      puts 'Choose carriage type:'
      puts '1. Passenger'
      puts '2. Cargo'
      type = { 1 => :passenger, 2 => :cargo }[gets.chomp.to_i]

      puts 'Enter manufacturer name:'
      manufacturer_name = gets.chomp
      { number:, type:, manufacturer_name: }
    end
  end

  def list_carriages
    navigation.bind('List carriages:', :list_carriages, :manage_carriages)
  end

  def list_carriages_in_train
    navigation.bind('List carriages in train:', :list_carriages_in_train, :manage_carriages) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp

      { train_index: }
    end
  end

  def attach_carriage
    navigation.bind('Attach carriage to train', :add_carriage, :manage_carriages) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp

      puts navigation.send_action(:list_carriages)
      puts 'Choose carriage:'
      carriage_index = gets.chomp
      { train_index:, carriage_index: }
    end
  end

  def detach_carriage
    navigation.bind('Detach carriage from train', :remove_carriage, :manage_carriages) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp

      puts navigation.send_action(:list_carriages_in_train, train_index:)
      puts 'Choose carriage:'
      carriage_index = gets.chomp
      { train_index:, carriage_index: }
    end
  end
end
# rubocop:enable all
