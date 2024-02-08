# frozen_string_literal: true

LATIN_ALPHABET = ("a".."z")
LATIN_VOWELS = %w[a e i o u].freeze

def find_vowels
  vowels = {}
  LATIN_ALPHABET.each.with_index(1) do |letter, index|
    vowels[letter] = index if LATIN_VOWELS.include?(letter)
  end
  vowels
end

def main
  puts find_vowels.inspect
end

main if $PROGRAM_NAME == __FILE__
