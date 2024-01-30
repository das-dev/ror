# frozen_string_literal: true

# rubocop:disable Style/Documentation
class Navigation
  def initialize(initial_state)
    @transitions = {}
    @state = initial_state
    @initial_state = make_initial_state(initial_state)
  end

  def display
    puts transitions[state][:title]
    handler = transitions[state][:handler] || initial_state.handler
    handler.call
  end

  def process_event
    new_state = transitions[state][:redirect]
    new_state ||= transitions[state][:choices][gets.chomp]
    new_state ||= initial_state
    self.state = new_state.key
  end

  def exit?
    state == :exit
  end

  def make(title, key, &block)
    menu = Menu.new({})
    block.call(menu)

    transitions[key] = { title:, choices: menu.choices }
  end

  def bind(title, key, controller, redirect_to, &block)
    redirect = Struct.new(:key).new(redirect_to)
    params = block_given? ? block : -> { {} }

    transitions[key] = { title:, redirect:, choices: {} }
    transitions[key][:handler] = lambda {
      puts controller.send(key, **params.call)
    }
  end

  private

  attr_accessor :state, :transitions, :initial_state

  def clear_screen
    system 'clear'
  end

  def make_initial_state(state)
    Struct.new(:key, :handler).new(state, -> { default_handler })
  end

  def default_handler
    transitions[state][:choices].each do |id, choice|
      puts "#{id}. #{choice.title}"
    end
    puts 'Choose an option:'
  end

  Menu = Struct.new(:choices) do
    def choice(title, key, id, &block)
      handler = block_given? ? block : -> {}
      choices[id] = Struct.new(:title, :key, :handler).new(title, key, handler)
    end
  end
end
# rubocop:enable all
