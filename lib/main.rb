# frozen_string_literal: true

require_relative 'ui/navigation'
require_relative 'ui/main_menu'
require_relative 'ui/manage_stations'
require_relative 'ui/manage_trains'
require_relative 'ui/manage_routes'

require_relative 'controllers/station_controller'
require_relative 'controllers/train_controller'
require_relative 'controllers/route_controller'

require_relative 'storage/key_value_storage'

# rubocop:disable Style/Documentation
class Application
  def initialize
    storage = KeyValueStorage.new
    @station_controller = StationController.new(storage)
    @train_controller = TrainController.new(storage)
    @route_controller = RouteController.new(storage, @station_controller)

    @navigation = Navigation.new(:main_menu)
  end

  def run
    make_menu

    until navigation.exit?
      navigation.display
      navigation.process(gets.chomp)
    end
  end

  private

  attr_reader :station_controller, :train_controller, :route_controller, :navigation

  def make_menu
    MainMenu.new(navigation).make_menu
    ManageStations.new(navigation, station_controller).make_menu
    ManageTrains.new(navigation, train_controller).make_menu
    ManageRoutes.new(navigation, route_controller).make_menu
  end
end
# rubocop:enable all

Application.new.run if $PROGRAM_NAME == __FILE__
