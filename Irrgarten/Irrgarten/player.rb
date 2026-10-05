# frozen_string_literal: true
require_relative 'dice'
require_relative 'weapon'
require_relative 'shield'
require_relative 'labyrinth_character'

module Irrgarten
  class Player < LabyrinthCharacter
    public_class_method :new

    # Atributos de clase

    @@MAX_WEAPONS = 2
    @@MAX_SHIELDS = 3
    @@INITIAL_HEALTH = 10
    @@HITS2LOSE = 3

    attr_reader :number, :row, :col

    # Métodos de instancia públicos

    def initialize(number, intelligence, strength)
      super("player #{number}", intelligence, strength, @@INITIAL_HEALTH)
      @number = number
      @consecutive_hits = 0
      @weapons = []
      @shields = []
    end

    def resurrect
      self.health = @@INITIAL_HEALTH
      @consecutive_hits = 0
      @weapons = []
      @shields = []
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def dead
      if @health <= 0
        true
      else
        false
      end
    end

    def move(direction, valid_moves)
      size = valid_moves.size
      contained = valid_moves.include?(direction)

      if size > 0 && !contained
        valid_moves[0]
      else
        direction
      end
    end

    def attack
      @strength + sum_weapons
    end

    def defend(received_attack)
      manage_hit(received_attack)
    end

    def receive_reward
      w_reward = Dice.weapons_reward
      s_reward = Dice.shields_reward

      for i in 1..w_reward
        wnew = new_weapon
        receive_weapon(wnew)
      end

      for i in 1..s_reward
        snew = new_shield
        receive_shield(snew)
      end

      extrahealth = Dice.health_reward
      self.health += extrahealth
    end

    def to_s
      "Jugador #{super}, Armas(#{@weapons.size}), Escudos(#{@shields.size})"
    end

    # Métodos de instancia privados

    def receive_weapon(w)
      i = @weapons.size - 1
      while i >= 0
        wi = @weapons[i]

        if wi.discard
          @weapons.delete_at(i)
        end

        i -= 1
      end

      size = @weapons.size
      if size < @@MAX_WEAPONS
        @weapons.push(w)
      end
    end

    def receive_shield(s)
      i = @shields.size - 1
      while i >= 0
        si = @shields[i]

        if si.discard
          @shields.delete_at(i)
        end

        i -= 1
      end

      size = @shields.size
      if size < @@MAX_SHIELDS
        @shields.push(s)
      end
    end

    def new_weapon
      power = Dice.weapon_power
      uses = Dice.uses_left
      Weapon.new(power, uses)
    end

    def new_shield
      protection = Dice.shield_power
      uses = Dice.uses_left
      Shield.new(protection, uses)
    end

    def sum_weapons
      total = 0.0
      for w in @weapons
        total += w.attack
      end
      total
    end

    def sum_shields
      total = 0.0
      for s in @shields
        total += s.protect
      end
      total
    end

    def defensive_energy
      @suma = @intelligence + sum_shields
      @suma
    end

    def manage_hit(received_attack)
      defense = defensive_energy

      if defense < received_attack
        got_wounded
        inc_consecutive_hits
      else
        reset_hits
      end

      if @consecutive_hits >= @@HITS2LOSE || dead
        reset_hits
        lose = true
      else
        lose = false
      end

      lose
    end

    def reset_hits
      @consecutive_hits = 0
    end

    def got_wounded
      @health -= 1
    end

    def inc_consecutive_hits
      @consecutive_hits += 1
    end

  end
end