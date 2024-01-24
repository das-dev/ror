# frozen_string_literal: true

MONTHS_WITH_DAYS = {
  'Январь' => 31,
  'Февраль' => 28,
  'Март' => 31,
  'Апрель' => 30,
  'Май' => 31,
  'Июнь' => 30,
  'Июль' => 31,
  'Август' => 31,
  'Сентябрь' => 30,
  'Октябрь' => 31,
  'Ноябрь' => 30,
  'Декабрь' => 31
}.freeze

def main
  MONTHS_WITH_DAYS.each { |month, days| puts month if days == 30 }
end

main if $PROGRAM_NAME == __FILE__
