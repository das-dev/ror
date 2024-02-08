# frozen_string_literal: true

def request_order_data
  order = []
  loop do
    name = request_name
    break if name == "стоп"

    price = request_price
    quantity = request_quantity

    order_item = { name:, price:, quantity: }
    order << order_item if valid_order_item?(order_item)
  end
  order
end

def request_name
  puts "Введите название товара:"
  gets.chomp
end

def request_price
  puts "Введите цену товара:"
  gets.chomp.to_f
end

def request_quantity
  puts "Введите количество товара:"
  gets.chomp.to_f
end

def valid_order_item?(order_item)
  if order_item[:name].empty?
    puts "Название товара не может быть пустым."
  elsif order_item[:price].negative?
    puts "Цена товара не может быть отрицательной."
  elsif order_item[:quantity].negative?
    puts "Количество товара не может быть отрицательным."
  else
    true
  end
end

def prepare_order_to_display(order)
  order.to_h do |order_item|
    [
      order_item[:name],
      {
        price: order_item[:price],
        quantity: order_item[:quantity],
        total_cost: order_item[:price] * order_item[:quantity]
      }
    ]
  end
end

def calc_total_cost(order)
  order.values.sum { |order_item| order_item[:total_cost] }
end

def make_output_message(order, total_cost)
  puts "Ваш заказ:"
  order.each.with_index(1) do |(name, item), i|
    puts make_order_row(name, item, i)
  end
  puts "Итого: #{total_cost}"
end

def make_order_row(name, order_item, num)
  "#{num}. #{name}: #{order_item[:price]} руб. x " \
    "#{order_item[:quantity]} шт. |  #{order_item[:total_cost]} руб."
end

def main
  order = request_order_data
  order_to_display = prepare_order_to_display(order)
  total_cost = calc_total_cost(order_to_display)

  make_output_message(order_to_display, total_cost)
end

main if $PROGRAM_NAME == __FILE__
