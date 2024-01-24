# frozen_string_literal: true

MONTHS_BY_DAYS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31].freeze

def leap_year?(year)
  (year % 4).zero? && (year % 100 != 0 || (year % 400).zero?)
end

def number_by_date(day, month, year)
  days_past = MONTHS_BY_DAYS[0...month - 1].sum
  days_past += 1 if leap_year?(year) && month > 2
  days_past + day
end

def request_date
  loop do
    puts 'Введите число, месяц и год через пробел:'
    date = gets.chomp.split.map(&:to_i)
    return date if valid_date?(date)

    puts 'Неверный формат даты'
  end
end

def valid_date?(date)
  day, month, _year = date
  return false unless valid_length?(date)
  return false unless all_positive?(date)
  return false unless valid_month?(month)
  return false unless valid_day?(day)

  true
end

def valid_length?(date)
  return true if date.size == 3

  puts 'Дата должна состоять из трех чисел.'
end

def all_positive?(date)
  return true if date.all?(&:positive?)

  puts 'Все числа должны быть больше нуля.'
end

def valid_month?(month)
  return true if month <= 12

  puts 'Месяц не может быть больше 12.'
end

def valid_day?(day)
  return true if day <= 31

  puts 'Число не может быть больше 31.'
end

def main
  puts number_by_date(*request_date)
end

main if $PROGRAM_NAME == __FILE__
