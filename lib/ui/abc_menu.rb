# frozen_string_literal: true

require_relative 'forms'

# rubocop:disable Style/Documentation
class AbcMenu
  include Forms

  def initialize(navigation)
    @navigation = navigation
  end

  def make_menu
    raise NotImplementedError
  end

  private

  attr_reader :navigation
end
# rubocop:enable all
