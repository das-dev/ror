# frozen_string_literal: true

require_relative 'abc_menu'

# rubocop:disable Style/Documentation
class ManageCarriages < AbcMenu
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
      number = enter_carriage_number
      type = choose_carriage_type
      manufacturer_name = enter_manufacturer_name
      extra_params = enter_carriage_extra_params(type)

      { number:, type:, manufacturer_name:, extra_params: }
    end
  end

  def list_carriages
    navigation.bind('List carriages:', :list_carriages, :manage_carriages)
  end

  def list_carriages_in_train
    navigation.bind('List carriages in train:', :list_carriages_in_train, :manage_carriages) do
      puts navigation.send_action(:list_trains)
      train_index = choose_train

      { train_index: }
    end
  end

  def attach_carriage
    navigation.bind('Attach carriage to train', :add_carriage, :manage_carriages) do
      puts navigation.send_action(:list_trains)
      train_index = choose_train

      puts navigation.send_action(:list_carriages)
      carriage_index = choose_carriage

      { train_index:, carriage_index: }
    end
  end

  def detach_carriage
    navigation.bind('Detach carriage from train', :remove_carriage, :manage_carriages) do
      puts navigation.send_action(:list_trains)
      train_index = choose_train

      puts navigation.send_action(:list_carriages_in_train, train_index:)
      carriage_index = choose_carriage

      { train_index:, carriage_index: }
    end
  end
end
# rubocop:enable all
