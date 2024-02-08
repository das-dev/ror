# frozen_string_literal: true

def request_sides
  loop do
    puts "Введите стороны прямоугльного треугольника через пробел:"
    sides = gets.chomp.strip.split.map(&:to_f)
    return sides if valid_sides?(sides)
  end
end

def valid_sides?(sides)
  if sides.size != 3
    puts "Треугольник должен иметь три стороны."
  elsif !sides.all?(&:positive?)
    puts "Длины сторон должны быть положительными."
  else
    true
  end
end

def check_triangle_properties(sides)
  {
    rectangular: sides.max**2 == sides.min(2).sum(&:abs2),
    equilateral: sides.uniq.size == 1,
    isosceles: sides.uniq.size == 2
  }
end

def make_output_message(triangle_properties)
  "Треугольник #{verbose_properties(triangle_properties)}."
end

def verbose_properties(triangle_properties)
  case triangle_properties
  in { equilateral: true } then "равносторонний"
  in { rectangular: true } then "прямоугольный"
  in { isosceles: true } then "равнобедренный"
  else "не равносторонний, не равнобедренный и не прямоугольный"
  end
end

def main
  sides = request_sides
  triangle_properties = check_triangle_properties(sides)
  puts make_output_message(triangle_properties)
end

main if $PROGRAM_NAME == __FILE__
