# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ManageTrains

  def initialize(navigation, train_controller)
    @navigation = navigation
    @train_controller = train_controller
  end

  def make_menu
    manage_trains
    move_trains
  end

  private

  attr_reader :train_controller, :navigation

  def manage_trains
    navigation.make('Manage Trains', :manage_trains) do |menu|
      create_train(menu, '1')
      list_trains(menu, '2')
      attach_carriage_to_train(menu, '3')
      detach_carriage_from_train(menu, '4')
      menu.choice 'Back to Main Menu', :main_menu, '0'
    end
  end

  def move_trains
    navigation.make('Move Trains', :move_trains) do |menu|
      move_train_forward_on_route(menu, '1')
      move_train_backward_on_route(menu, '2')
      menu.choice 'Back to Main Menu', :main_menu, '0'
    end
  end

  def create_train(menu, key)
    menu.choice('Create train', :create_train, key) do
      train_controller.create_train
      :manage_trains
    end
  end

  def list_trains(menu, key)
    menu.choice('List trains', :list_trains, key) do
      train_controller.list_trains
      :manage_trains
    end
  end

  def attach_carriage_to_train(menu, key)
    menu.choice('Attach carriage to train', :attach_carriage_to_train, key) do
      train_controller.attach_carriage_to_train
      :manage_trains
    end
  end

  def detach_carriage_from_train(menu, key)
    menu.choice('Detached carriage to train', :detach_carriage_from_train, key) do
      train_controller.detach_carriage_from_train
      :manage_trains
    end
  end

  def move_train_forward_on_route(menu, key)
    menu.choice('Move train forward on route', :move_train_forward_on_route, key) do
      train_controller.move_train_forward_on_route
      :move_trains
    end
  end

  def move_train_backward_on_route(menu, key)
    menu.choice('Move train forward on route', :move_train_backward_on_route, key) do
      train_controller.move_train_backward_on_route
      :move_trains
    end
  end
end
# rubocop:enable all
