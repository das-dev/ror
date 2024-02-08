# frozen_string_literal: true

class RouteTable
  def initialize
    @controllers = {}
    @actions = {}
    yield(self) if block_given?
    make_table
  end

  def register_controller(**controller_options)
    @controllers.merge!(controller_options)
  end

  def register_action(controller, action, handler)
    @actions[action] = controller.method(handler)
  end

  def send_action(action, **params)
    handler = resolve_action(action)
    return "Unknown action: #{action.inspect}" if handler.nil?

    handler.call(**params)
  end

  private

  def make_table
    @controllers.each_pair do |controller_name, controller|
      send("table_#{controller_name}", controller)
    end
  end

  # private ибо хелпер
  def resolve_action(action)
    @actions[action]
  end

  # private ибо нечего снаружи лезть напрямую в таблицы
  def table_station_controller(controller)
    register_action(controller, :create_station, :create_station)
    register_action(controller, :list_stations, :list_stations)
    register_action(controller, :list_trains_on_station, :list_trains_on_station)
  end

  def table_train_controller(controller)
    register_action(controller, :create_train, :create_train)
    register_action(controller, :list_trains, :list_trains)
    register_action(controller, :show_train, :show_train)
    register_action(controller, :set_route, :assign_route_to_train)
    register_action(controller, :find_train, :find_train_by_number)
    register_action(controller, :move_forward, :move_forward)
    register_action(controller, :move_backward, :move_backward)
  end

  def table_carriage_controller(controller)
    register_action(controller, :create_carriage, :create_carriage)
    register_action(controller, :list_carriages, :list_carriages)
    register_action(controller, :add_carriage, :attach_carriage)
    register_action(controller, :remove_carriage, :detach_carriage)
    register_action(controller, :list_carriages_in_train, :list_carriages_in_train)
    register_action(controller, :occupy_carriage_seat, :occupy_carriage_seat)
    register_action(controller, :occupy_carriage_volume, :occupy_carriage_volume)
  end

  def table_route_controller(controller)
    register_action(controller, :create_route, :create_route)
    register_action(controller, :list_routes, :list_routes)
    register_action(controller, :add_station, :add_intermediate_station)
    register_action(controller, :remove_station, :remove_intermediate_station)
  end

  def table_application_controller(controller)
    register_action(controller, :about, :about)
    register_action(controller, :stat, :stat)
  end
end
