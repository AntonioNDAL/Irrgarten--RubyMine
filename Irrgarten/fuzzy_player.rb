# frozen_string_literal: true
module Irrgarten
  class FuzzyPlayer < Player
    def initialize(other)
      copy(other)
    end

    def move(direction, valid_moves)
      pref = super(direction, valid_moves)
      Dice.next_step(pref, valid_moves, intelligence)
    end

    def attack
      sum_weapons + Dice.intensity(strength)
    end

    def defend(received_attack)
      super(received_attack)
    end

    def to_s
      "Fuzzy #{super}"
    end
  end
end

