require_relative 'Irrgarten/game'
require_relative 'UI/textUI'
require_relative 'Control/controller'
require_relative './Irrgarten/weapon'

class TestP3
  def main
    arma = Weapon.new(3.5, 4)

    at = arma.attack()
    cadena = arma.to_s()
    descartar = arma.discard()

    #numJugadores = 1
    #vista = UI::TextUI.new()
    #game = Irrgarten::Game.new(numJugadores)
    #controlador = Control::Controller.new(game, vista)

    #controlador.play
  end
end