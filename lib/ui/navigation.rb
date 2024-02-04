# frozen_string_literal: true

require_relative '../controllers/exceptions'

# rubocop:disable Style/Documentation
class Navigation
  def initialize(router, initial_state)
    @transitions = {}
    @router = router
    @state = initial_state
    @initial_state = make_initial_state(initial_state)
  end

  def display
    clear_screen
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

  def bind(title, key, redirect_to, attempts: 0, &block)
    redirect = Struct.new(:key).new(redirect_to)
    form = block_given? ? block : -> { {} }

    transitions[key] = { title:, redirect:, attempts:, choices: {} }
    transitions[key][:handler] = lambda do
      try_to_send_action(key, form, attempts)
    end
  end

  def send_action(action, **params)
    router.send_action(action, **params)
  end

  private

  # private потому что детали реализации
  attr_accessor :router, :state, :transitions, :initial_state

  # снаружи не нужен
  def clear_screen
    system 'clear'
  end

  def try_to_send_action(key, form, attempts_left = 0)
    puts send_action(key, **form.call)
    puts 'Press Enter to continue...'
    gets
  rescue ControllerError => e
    clear_screen
    puts e.message
    retry unless (attempts_left -= 1).negative?
  end

  # внутренние хелперы
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
