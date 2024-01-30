# frozen_string_literal: true

require_relative 'route_table'

require_relative 'ui/navigation'
require_relative 'ui/main_menu'
require_relative 'ui/manage_stations'
require_relative 'ui/manage_trains'
require_relative 'ui/manage_routes'
require_relative 'ui/move_trains'

require_relative 'controllers/station_controller'
require_relative 'controllers/train_controller'
require_relative 'controllers/route_controller'
require_relative 'controllers/application_controller'

require_relative 'storage/key_value_storage'

# rubocop:disable Style/Documentation
class Application
  def initialize
    storage = KeyValueStorage.new
    station_controller = StationController.new(storage)
    train_controller = TrainController.new(storage)
    route_controller = RouteController.new(storage)
    application_controller = ApplicationController.new(storage)
    router = RouteTable.new(station_controller, route_controller, train_controller, application_controller)

    @navigation = Navigation.new(router, :main_menu)
  end

  def run
    make_menu

    until navigation.exit?
      navigation.display
      navigation.process_event
    end
  end

  private

  attr_reader :navigation

  # приватный потому что снаружи нужен только run
  def make_menu
    MainMenu.new(navigation).make_menu
    ManageStations.new(navigation).make_menu
    ManageTrains.new(navigation).make_menu
    ManageRoutes.new(navigation).make_menu
    MoveTrains.new(navigation).make_menu
  end
end
# rubocop:enable all

Application.new.run if $PROGRAM_NAME == __FILE__
