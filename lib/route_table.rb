# frozen_string_literal: true

class RouteTable
  def initialize(station_controller, carriage_controller,
                 train_controller, route_controller,
                 application_controller)
    @station_controller = station_controller
    @route_controller = route_controller
    @train_controller = train_controller
    @carriage_controller = carriage_controller
    @application_controller = application_controller
  end

  def send_action(action, **params)
    handler = resolve_action(action)
    return "Unknown action" if handler.nil?

    handler.call(**params)
  end

  private

  # private потому что не часть интерфейса
  attr_reader :station_controller, :route_controller, :train_controller,
              :carriage_controller, :application_controller

  # private ибо хелпер
  def resolve_action(action)
    table_station_management_controller[action] ||
      table_train_management_controller[action] ||
      table_train_movement_controller[action]   ||
      table_route_management_controller[action] ||
      table_carriage_management_controller[action] ||
      table_app_controller[action]
  end

  # private ибо нечего снаружи лезть напрямую в таблицы
  def table_station_management_controller
    {
      create_station: station_controller.method(:create_station),
      list_stations: station_controller.method(:list_stations),
      list_trains_on_station: station_controller.method(:list_trains_on_station)
    }
  end

  def table_train_management_controller
    {
      create_train: train_controller.method(:create_train),
      list_trains: train_controller.method(:list_trains),
      show_train: train_controller.method(:show_train),
      set_route: train_controller.method(:assign_route_to_train),
      find_train: train_controller.method(:find_train_by_number)
    }
  end

  def table_train_movement_controller
    {
      move_forward: train_controller.method(:move_forward),
      move_backward: train_controller.method(:move_backward)
    }
  end

  def table_carriage_management_controller
    {
      create_carriage: carriage_controller.method(:create_carriage),
      list_carriages: carriage_controller.method(:list_carriages),
      add_carriage: carriage_controller.method(:attach_carriage),
      remove_carriage: carriage_controller.method(:detach_carriage),
      list_carriages_in_train: carriage_controller.method(:list_carriages_in_train),
      occupy_carriage_seat: carriage_controller.method(:occupy_carriage_seat),
      occupy_carriage_volume: carriage_controller.method(:occupy_carriage_volume)
    }
  end

  def table_route_management_controller
    {
      create_route: route_controller.method(:create_route),
      list_routes: route_controller.method(:list_routes),
      add_station: route_controller.method(:add_intermediate_station),
      remove_station: route_controller.method(:remove_intermediate_station)
    }
  end

  def table_app_controller
    {
      about: application_controller.method(:about),
      stat: application_controller.method(:stat)
    }
  end
end
