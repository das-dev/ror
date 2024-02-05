# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

class GeneralScenariosTest < Minitest::Test
  include Scenarios

  def setup
    @helper = TestHelper.new
    @input = @helper.input
    @output = @helper.output
  end

  def test_main_menu
    scenario_quit

    @helper.run_app

    assert_equal TestHelper::MAIN_MENU, @output.string
  end
end
