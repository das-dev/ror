# frozen_string_literal: true

# rubocop:disable Style/Documentation
class RouteTable
  def initialize(station_controller, route_controller, train_controller, application_controller)
    @station_controller = station_controller
    @route_controller = route_controller
    @train_controller = train_controller
    @application_controller = application_controller
  end

  def send_action(action, **params)
    path = resolve_action(action)
    return 'Unknown action' if path.nil?

    controller, handler = path
    send(controller).send(handler, **params)
  end

  private

  # private потому что не часть интерфейса
  attr_reader :station_controller, :route_controller, :train_controller, :application_controller

  # private ибо хелпер
  def resolve_action(action)
    table_station_controller[action] ||
      table_train_controller[action] ||
      table_route_controller[action] ||
      table_app_controller[action]
  end

  # private ибо нечего снаружи лезть напрямую в таблицы
  def table_station_controller
    {
      create_station: %i[station_controller create_station],
      list_stations: %i[station_controller list_stations],
      list_trains_on_station: %i[station_controller list_trains_on_station]
    }
  end

  def table_train_controller
    {
      create_train: %i[train_controller create_train],
      list_trains: %i[train_controller list_trains],
      add_carriage: %i[train_controller attach_carriage],
      show_train: %i[train_controller show_train],
      remove_carriage: %i[train_controller detach_carriage],
      set_route: %i[train_controller assign_route_to_train],
      find_train: %i[train_controller find_train_by_number],
      move_forward: %i[train_controller move_forward],
      move_backward: %i[train_controller move_backward]
    }
  end

  def table_route_controller
    {
      create_route: %i[route_controller create_route],
      list_routes: %i[route_controller list_routes],
      add_station: %i[route_controller add_intermediate_station],
      remove_station: %i[route_controller remove_intermediate_station]
    }
  end

  def table_app_controller
    {
      about: %i[application_controller about],
      stat: %i[application_controller stat],
    }
  end
end
# rubocop:enable all
