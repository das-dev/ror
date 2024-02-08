# frozen_string_literal: true

require_relative "abc_menu"

class MoveTrains < AbcMenu
  def make_menu
    move_trains
    move_forward
    move_backward
  end

  private

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def move_trains
    navigation.make("Move Trains", :move_trains) do |menu|
      menu.choice("Move train forward on route", :move_forward, "1")
      menu.choice("Move train backward on route", :move_backward, "2")
      menu.choice("Back to Main Menu", :main_menu, "0")
      menu.choice("Quit", :exit, "q")
    end
  end

  def move_forward
    navigation.bind("Move train forward on route", :move_forward, :move_trains) do
      puts navigation.send_action(:list_trains)
      train_index = choose_train

      { train_index: }
    end
  end

  def move_backward
    navigation.bind("Move train backward on route", :move_backward, :move_trains) do
      puts navigation.send_action(:list_trains)
      train_index = choose_train

      { train_index: }
    end
  end
end
