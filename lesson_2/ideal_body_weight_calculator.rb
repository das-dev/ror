# frozen_string_literal: true

User = Data.define(:name, :height)

def make_user
  puts "Введите ваше имя:"
  user_name = gets.chomp.strip

  puts "Введите ваш рост в сантиметрах:"
  actual_height = gets.chomp.to_i

  User.new(user_name, actual_height)
end

def calculate_ideal_body_weight(height)
  (height - 110) * 1.15
end

def make_output_message(ideal_body_weight, user)
  message = "#{user.name}, ваш идеальный вес #{ideal_body_weight} кг."
  ideal_body_weight.negative? ? "Ваш идеальный вес уже оптимальный" : message
end

def main
  user = make_user
  ideal_body_weight = calculate_ideal_body_weight(user.height)
  puts make_output_message(ideal_body_weight, user)
end

main if $PROGRAM_NAME == __FILE__
