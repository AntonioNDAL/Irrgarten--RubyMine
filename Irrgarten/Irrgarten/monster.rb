# frozen_string_literal: true
require_relative 'dice'
require_relative 'labyrinth_character'

module Irrgarten
  class Monster < LabyrinthCharacter
    public_class_method :new
    @@INITIAL_HEALTH = 5

    def initialize(name, intelligence, strength)
      super(name, intelligence, strength, @@INITIAL_HEALTH)
    end

    def attack
      Dice.intensity(@strength)
    end

    def defend(received_attack)
      is_dead = dead

      if !is_dead
        defensive_energy = Dice.intensity(@intelligence)

        if defensive_energy < received_attack
          got_wounded
          is_dead = dead
        end
      end

      is_dead
    end

  end
end