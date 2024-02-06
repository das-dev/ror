# frozen_string_literal: true

require_relative 'abc_menu'

# rubocop:disable Style/Documentation
class MainMenu < AbcMenu
  def make_menu
    main_menu
    about
    stat
  end

  private

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def main_menu
    navigation.make('Main AbcMenu', :main_menu) do |menu|
      menu.choice 'Manage Stations', :manage_stations, '1'
      menu.choice 'Manage Carriages', :manage_carriages, '2'
      menu.choice 'Manage Trains', :manage_trains, '3'
      menu.choice 'Manage Routes', :manage_routes, '4'
      menu.choice 'Move Trains', :move_trains, '5'
      menu.choice 'About app', :about, 'a'
      menu.choice 'Stat', :stat, 's'
      menu.choice 'Quit', :exit, 'q'
    end
  end

  def about
    navigation.bind('About app', :about, :main_menu)
  end

  def stat
    navigation.bind('Stat', :stat, :main_menu)
  end
end
# rubocop:enable all
