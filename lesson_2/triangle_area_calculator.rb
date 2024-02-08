# frozen_string_literal: true

Triangle = Struct.new(:base, :height, :area)

def make_triangle
  prompt = "Введите основание треугольника:"
  error_message = "Основание треугольника должно быть больше нуля."
  triangle_base = request_positive_value(prompt, error_message)

  prompt = "Введите высоту треугольника:"
  error_message = "Высота треугольника должна быть больше нуля."
  triangle_height = request_positive_value(prompt, error_message)

  Triangle.new(triangle_base, triangle_height)
end

def request_positive_value(prompt, error_message)
  loop do
    puts prompt
    value = gets.chomp.to_i
    return value if value.positive?

    puts error_message
  end
end

def calculate_triangle_area(triangle)
  0.5 * triangle.base * triangle.height
end

def make_output_message(triangle)
  "Площадь треугольника с высотой #{triangle.height} " \
    "и основанием #{triangle.base} равна #{triangle.area}"
end

def main
  triangle = make_triangle
  triangle.area = calculate_triangle_area(triangle)
  puts make_output_message(triangle)
end

main if $PROGRAM_NAME == __FILE__
