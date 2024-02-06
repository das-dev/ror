# frozen_string_literal: true

require_relative 'abc_menu'

# rubocop:disable Style/Documentation
class ManageTrains < AbcMenu
  def make_menu
    manage_trains
    create_train
    list_trains
    show_train
    assign_route
    find_train
  end

  private

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def manage_trains
    navigation.make('Manage Trains', :manage_trains) do |menu|
      menu.choice('Create train', :create_train, '1')
      menu.choice('List trains', :list_trains, '2')
      menu.choice('Show train', :show_train, '3')
      menu.choice('Set route to train', :set_route, '4')
      menu.choice('Back to Main AbcMenu', :main_menu, '0')
      menu.choice('Find train by number', :find_train, 'f')
      menu.choice('Quit', :exit, 'q')
    end
  end

  def create_train
    navigation.bind('Create train form', :create_train, :manage_trains, attempts: 3) do
      number = enter_train_number
      type = choose_train_type
      manufacturer_name = enter_manufacturer_name

      { number:, type:, manufacturer_name: }
    end
  end

  def list_trains
    navigation.bind('List trains:', :list_trains, :manage_trains)
  end

  def show_train
    navigation.bind('Show train:', :show_train, :manage_trains) do
      puts navigation.send_action(:list_trains)
      train_index = choose_train

      { train_index: }
    end
  end

  def assign_route
    navigation.bind('Set route to train', :set_route, :manage_trains) do
      puts navigation.send_action(:list_trains)
      train_index = choose_train

      puts navigation.send_action(:list_routes)
      route_index = choose_route

      { route_index:, train_index: }
    end
  end

  def find_train
    navigation.bind('Find train by number', :find_train, :manage_trains) do
      number = enter_train_number

      { number: }
    end
  end
end
# rubocop:enable all
