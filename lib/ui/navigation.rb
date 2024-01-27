# frozen_string_literal: true

# rubocop:disable Style/Documentation
class Navigation
  def initialize
    @transitions = {}
    @state = :main_menu
  end

  def display
    puts transitions[state][:title]
    transitions[state][:choices].each do |id, choice|
      puts "#{id}. #{choice.title}"
    end
    puts 'Choose an option:'
  end

  def process(event)
    new_state = transitions[state][:choices][event]
    state = new_state.key
    self.state = new_state.handler.call || state
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

  attr_accessor :state, :transitions

  Menu = Struct.new(:choices) do
    def choice(title, key, id, &block)
      handler = block_given? ? block : -> {}
      choices[id] = Struct.new(:title, :key, :handler).new(title, key, handler)
    end
  end
end
# rubocop:enable all
