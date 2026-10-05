# frozen_string_literal: true
require_relative 'combat_element'

module Irrgarten
  class Weapon < CombatElement
    public_class_method::new

    def initialize(power, uses)
      super #en Ruby al hacer super coge el método del padre, y si no le das elementos coge los del método
    end
    #También podríamos no poner initialize ya que lo hereda.

    def attack()
      produceEffect
    end

    def to_s
      "W" + super
    end

  end
end