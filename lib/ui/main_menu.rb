# frozen_string_literal: true

# rubocop:disable Style/Documentation
class MainMenu
  def initialize(navigation)
    @navigation = navigation
  end

  def make_menu
    main_menu
  end

  private

  attr_reader :navigation

  def main_menu
    navigation.make('Main Menu', :main_menu) do |menu|
      menu.choice 'Manage Stations', :manage_stations, '1'
      menu.choice 'Manage Trains', :manage_trains, '2'
      menu.choice 'Manage Routes', :manage_routes, '3'
      menu.choice 'Move Trains', :move_trains, '4'
      menu.choice 'Quit', :exit, 'q'
    end
  end
end
# rubocop:enable all
