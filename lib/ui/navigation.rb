# frozen_string_literal: true

# rubocop:disable Style/Documentation
class Navigation
  def initialize(initial_state)
    @transitions = {}
    @state = initial_state
    @initial_state = Struct.new(:key, :handler).new(initial_state, -> {})
  end

  def display
    puts transitions[state][:title]
    transitions[state][:choices].each do |id, choice|
      puts "#{id}. #{choice.title}"
    end
    puts 'Choose an option:'
  end

  def process(event)
    clear_screen
    new_state = transitions[state][:choices][event] || initial_state
    self.state = new_state.handler.call || new_state.key
  end

  def exit?
    state == :exit
  end

  def make(title, key, &block)
    menu = Menu.new({})
    block.call(menu)

    transitions[key] = { title:, choices: menu.choices }
  end

  private

  attr_accessor :state, :transitions, :initial_state

  def clear_screen
    system 'clear'
  end

  Menu = Struct.new(:choices) do
    def choice(title, key, id, &block)
      handler = block_given? ? block : -> {}
      choices[id] = Struct.new(:title, :key, :handler).new(title, key, handler)
    end
  end
end
# rubocop:enable all
