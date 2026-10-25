# frozen_string_literal: true
require_relative 'dice'

module Irrgarten
  class Shield < CombatElement

    def initialize (protection, uses)
      super
    end

    def protect
      produce_effect
    end

    def to_s
      "S" + super
    end

  end
end