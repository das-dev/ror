# frozen_string_literal: true

require_relative "route_table"

require_relative "ui/main_menu"
require_relative "ui/manage_carriages"
require_relative "ui/manage_routes"
require_relative "ui/manage_stations"
require_relative "ui/manage_trains"
require_relative "ui/move_trains"
require_relative "ui/navigation"

require_relative "controllers/application_controller"
require_relative "controllers/carriage_controller"
require_relative "controllers/route_controller"
require_relative "controllers/station_controller"
require_relative "controllers/train_controller"

require_relative "storage/key_value_storage"

class Application
  def initialize
    @storage = KeyValueStorage.new
    @route = make_route_table
    @navigation = Navigation.new(@route, :main_menu)
  end

  def run
    make_menu

    until navigation.exit?
      navigation.display
      navigation.process_event
    end
  end

  private

  attr_reader :navigation, :storage

  # приватный потому что снаружи нужен только run
  def make_menu
    MainMenu.new(navigation).make_menu
    AbcMenu.subclasses.each do |klass|
      klass.new(navigation).make_menu
    end
  end

  def make_route_table
    RouteTable.new do |table|
      table.register_controller(station_controller: StationController.new(storage))
      table.register_controller(carriage_controller: CarriageController.new(storage))
      table.register_controller(train_controller: TrainController.new(storage))
      table.register_controller(route_controller: RouteController.new(storage))
      table.register_controller(application_controller: ApplicationController.new(storage))
    end
  end
end

Application.new.run if $PROGRAM_NAME == __FILE__
