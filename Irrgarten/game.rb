# frozen_string_literal: true
require_relative 'dice'
require_relative 'labyrinth'
require_relative 'player'
require_relative 'monster'
require_relative 'game_state'
require_relative 'directions'
require_relative 'game_character'
require_relative 'orientation'
require_relative 'fuzzy_player'

module Irrgarten
  class Game
    @@MAX_ROUNDS = 10
    @@N_MONSTERS = 3
    @@LABYRINTH_ROWS = 7
    @@LABYRINTH_COLS = 5
    @@EXIT_ROW = 4
    @@EXIT_COL = 3

    def initialize(nplayers)
      @players = []
      for n in 0...nplayers
        @players << Player.new(n, Dice.random_intelligence, Dice.random_strength)
      end

      @monsters = []
      @num_current_player = Dice.who_starts(nplayers)
      @current_player = @players[@num_current_player]
      @log = ""

      @labyrinth = Labyrinth.new(@@LABYRINTH_ROWS, @@LABYRINTH_COLS, @@EXIT_ROW, @@EXIT_COL)
      self.configure_labyrinth
      @labyrinth.spread_players(@players)
    end

    def finished
      @labyrinth.have_a_winner
    end

    def next_step(nDirection)
      @log = ""
      end_game = false

      dead = @current_player.dead

      if dead
        manage_resurrection
      else
        direction = actual_direction(nDirection)

        if direction != nDirection
          log_player_no_orders
        end

        monster = @labyrinth.put_player(direction, @current_player)

        if monster == nil
          log_no_monster
        else
          winner = combat(monster)
          manage_reward(winner)
        end
      end

      end_game = finished
      if !end_game
        next_player
      end

      end_game
    end

    def get_game_state
      players_string = ""
      for p in @players
        players_string += p.to_s + "\n"
      end

      monsters_string = ""
      for m in @monsters
        monsters_string += m.to_s + "\n"
      end

      Game_state.new(@labyrinth.to_s, players_string, monsters_string, @num_current_player, self.finished, @log)
    end

    def configure_labyrinth
      @labyrinth.add_block(Orientation::VERTICAL, 1,1,5)
      @labyrinth.add_block(Orientation::VERTICAL, 0,3,2)
      @labyrinth.add_block(Orientation::HORIZONTAL, 2,2,4)

      for n in 0...@@N_MONSTERS
        monster = Monster.new("Monstruo #{n}", Dice.random_intelligence, Dice.random_strength)
        row, col = @labyrinth.random_empty_pos

        @labyrinth.add_monster(row, col, monster)
        @monsters.push(monster)
      end
    end

    def next_player
      @num_current_player = (@num_current_player + 1) % @players.length
      @current_player = @players[@num_current_player]
    end

    def actual_direction(nDirection)
      current_row = @current_player.row
      current_col = @current_player.col

      valid_moves = @labyrinth.validMoves(current_row, current_col)

      @current_player.move(nDirection, valid_moves)
    end

    def combat(monster)
      rounds = 0
      winner = Game_character::PLAYER

      player_attack = @current_player.attack
      lose = monster.defend(player_attack)

      while !lose && rounds < @@MAX_ROUNDS
        winner = Game_character::MONSTER
        rounds += 1

        monster_attack = monster.attack
        lose = @current_player.defend(monster_attack)

        if !lose
          winner = Game_character::PLAYER
          player_attack = @current_player.attack
          lose = monster.defend(player_attack)
        end
      end

      log_rounds(rounds, @@MAX_ROUNDS)
      winner
    end

    def manage_reward(winner)
      if winner == Game_character::PLAYER
        @current_player.receive_reward
        log_player_won
      else
        log_monster_won
      end
    end

    def manage_resurrection
      resurrect = Dice.resurrect_player

      if resurrect
        @current_player.resurrect
        log_resurrected
      else
        if !@current_player.is_a?(FuzzyPlayer)
          fuzzy = FuzzyPlayer.new(@current_player)
          @players[@num_current_player] = fuzzy
          @current_player = fuzzy
          @labyrinth.put_player_2d(-1, -1, @current_player.row, @current_player.col, @current_player)
          log_player_skip_turn
        end
      end

    end

    def log_player_won
      @log += "El jugador ha ganado el combate.\n"
    end

    def log_monster_won
      @log += "El monstruo ha ganado el combate.\n"
    end

    def log_resurrected
      @log += "El jugador ha resucitado.\n"
    end

    def log_player_skip_turn
      @log += "El jugador ha perdido el turno por estar muerto.\n"
    end

    def log_player_no_orders
      @log += "El jugador no ha seguido las instrucciones del jugador humano.\n"
    end

    def log_no_monster
      @log += "El jugador se ha movido a una celda vacía o  no le ha sido posible moverse.\n"
    end

    def log_rounds(rounds, max)
      @log += "Se han producido #{rounds} de #{max} rondas de combate.\n"
    end

  end
end