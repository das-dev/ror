# frozen_string_literal: true

# rubocop:disable Style/Documentation
class AbcMenu
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
