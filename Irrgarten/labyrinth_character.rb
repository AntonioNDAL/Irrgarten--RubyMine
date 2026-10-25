# frozen_string_literal: true

module Irrgarten
  class LabyrinthCharacter
    private_class_method :new
    
    attr_reader :name, :row, :col
    attr_accessor :health

    def initialize(name, intelligence, strength, health)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = health
      @row = -1
      @col = -1
    end

    protected

    def intelligence
      @intelligence
    end

    def strength
      @strength
    end

    def got_wounded
      @health -= 1
    end
    
    public

    def copy(other)
      @name = other.name
      @intelligence = other.intelligence
      @strength = other.strength
      @health = other.health
      @row = other.row
      @col = other.col
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

  end
end
