# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

class GeneralUseCasesTest < Minitest::Test
  def setup
    @helper = TestHelper.new
  end

  def test_main_menu
    @helper.scenario_quit

    @helper.run_app

    assert_equal TestHelper::MAIN_MENU, @helper.output.string
  end
end
