# frozen_string_literal: true

require_relative 'menu'

# rubocop:disable Style/Documentation
class MoveTrains < Menu
  def make_menu
    move_trains
    move_forward
    move_backward
  end

  private

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def move_trains
    navigation.make('Move Trains', :move_trains) do |menu|
      menu.choice('Move train forward on route', :move_forward, '1')
      menu.choice('Move train backward on route', :move_backward, '2')
      menu.choice('Back to Main Menu', :main_menu, '0')
      menu.choice('Quit', :exit, 'q')
    end
  end

  def move_forward
    navigation.bind('Move train forward on route', :move_forward, :move_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp
      { train_index: }
    end
  end

  def move_backward
    navigation.bind('Move train backward on route', :move_backward, :move_trains) do
      puts navigation.send_action(:list_trains)
      puts 'Choose train:'
      train_index = gets.chomp
      { train_index: }
    end
  end
end
# rubocop:enable all
