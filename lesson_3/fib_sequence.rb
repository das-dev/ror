# frozen_string_literal: true

def fib_sequence(number)
  sequence = [0]
  fib_number = 1

  loop do
    sequence << fib_number
    fib_number = sequence.last(2).sum
    break if fib_number > number
  end
  sequence
end

def main
  puts fib_sequence(100).inspect
end

main if $PROGRAM_NAME == __FILE__
