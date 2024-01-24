# frozen_string_literal: true

def main
  (10..100).step(5) { |number| puts number }
end

main if $PROGRAM_NAME == __FILE__
