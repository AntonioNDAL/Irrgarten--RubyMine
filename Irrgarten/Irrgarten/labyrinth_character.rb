# frozen_string_literal: true

module Irrgarten
  class LabyrinthCharacter
    private_class_method :new

    def initialize(name, intelligence, strength, health)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = health
      @row = -1
      @col = -1
    end

    protected

    def got_wounded
      @health -= 1
    end

    def get_intelligence
      @intelligence
    end

    def get_strength
      @strength
    end

    def get_health
      @health
    end

    def set_health(health)
      @health = health
    end

    public

    def copy(other)
      @name = other.name
      @intelligence = other.get_intelligence
      @strength = other.get_strength
      @health = other.get_health
      @row = other.get_row
      @col = other.get_col
    end

    def dead
      @health <= 0
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def to_s
      "#{@name}: Inteligencia(#{@intelligence}), Fuerza(#{@strength}), Salud(#{@health}), Posición(#{@row})(#{@col})"
    end

    def get_row
      @row
    end

    def get_col
      @col
    end

  end
end