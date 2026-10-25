#encoding:utf-8
require_relative 'Irrgarten/game'
require_relative 'UI/textUI'
require_relative 'Control/controller'

class TestP3
  def main
    numJugadores = 1
    vista = UI::TextUI.new
    game = Irrgarten::Game.new(numJugadores)
    controlador = Control::Controller.new(game, vista)

    controlador.play
  end
end

TestP3.new.main
