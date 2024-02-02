# frozen_string_literal: true

# rubocop:disable Style/Documentation
class MainMenu
  def initialize(navigation)
    @navigation = navigation
  end

  def make_menu
    main_menu
    about
    stat
  end

  private

  attr_reader :navigation

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def main_menu
    navigation.make('Main Menu', :main_menu) do |menu|
      menu.choice 'Manage Stations', :manage_stations, '1'
      menu.choice 'Manage Trains', :manage_trains, '2'
      menu.choice 'Manage Routes', :manage_routes, '3'
      menu.choice 'Move Trains', :move_trains, '4'
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
