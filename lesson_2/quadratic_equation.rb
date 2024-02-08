# frozen_string_literal: true

QuadraticCoefficients = Struct.new(:a, :b, :c)

def request_coefficients
  loop do
    puts "Введите три коэффициента (a, b и c) квадратного уравнения через пробел:"
    coefficients = gets.chomp.strip.split.map(&:to_f)
    return QuadraticCoefficients.new(*coefficients) if valid_coefficients?(coefficients)
  end
end

def valid_coefficients?(coefficients)
  return true if coefficients.size == 3

  puts "Недостаточно коэффициентов"
end

def calc_discriminant(coefficients)
  (coefficients.b**2) - (4 * coefficients.a * coefficients.c)
end

def make_output_message(discriminant, coefficients)
  "Дискриминант: #{discriminant}. " + verbose_roots(discriminant, coefficients)
end

def verbose_roots(discriminant, coefficients)
  if discriminant.positive?
    "Корни: #{calculate_two_roots(discriminant, coefficients).join(', ')}"
  elsif discriminant.zero?
    "Корень: #{calculate_single_root(coefficients)}"
  else
    "Нет корней"
  end
end

def calculate_two_roots(discriminant, coefficients)
  [
    (-coefficients.b + Math.sqrt(discriminant)) / (2 * coefficients.a),
    (-coefficients.b - Math.sqrt(discriminant)) / (2 * coefficients.a)
  ]
end

def calculate_single_root(coefficients)
  -coefficients.b / (2 * coefficients.a)
end

def main
  quadratic_coefficients = request_coefficients
  discriminant = calc_discriminant(quadratic_coefficients)
  puts make_output_message(discriminant, quadratic_coefficients)
end

main if $PROGRAM_NAME == __FILE__
