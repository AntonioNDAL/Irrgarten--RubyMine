# frozen_string_literal: true
require_relative 'combat_element'

module Irrgarten
  class Weapon < CombatElement
    public_class_method :new

    def initialize(power, uses)
      super 
    end

    def attack
      produce_effect
    end

    def to_s
      "W#{super}"
    end
  end
end
