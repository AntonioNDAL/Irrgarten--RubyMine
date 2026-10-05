# frozen_string_literal: true
require_relative 'dice'
require_relative 'monster'
require_relative 'player'
require_relative 'directions'
require_relative 'orientation'

module Irrgarten
  class Labyrinth

    @@BLOCK_CHAR = 'X'
    @@EMPTY_CHAR = '-'
    @@MONSTER_CHAR = 'M'
    @@COMBAT_CHAR = 'C'
    @@EXIT_CHAR = 'E'
    @@ROW = 0
    @@COL = 1

    def initialize(n_rows, n_cols, exit_row, exit_col)
      @n_rows = n_rows
      @n_cols = n_cols
      @exit_row = exit_row
      @exit_col = exit_col

      @labyrinth = Array.new(@n_rows) { Array.new(@n_cols, @@EMPTY_CHAR) }
      @monsters = Array.new(@n_rows) { Array.new(@n_cols, nil) }
      @players = Array.new(@n_rows) { Array.new(@n_cols, nil) }

      @labyrinth[@exit_row][@exit_col] = @@EXIT_CHAR
    end

    def spread_players(players)
      for p in players
        pos = random_empty_pos
        put_player_2D(-1, -1, pos[@@ROW], pos[@@COL], p)
      end
    end

    def have_a_winner
      @players[@exit_row][@exit_col] != nil
    end

    def to_s
      output = ""
      for r in 0...@n_rows
        for c in 0...@n_cols
          output += "[#{@labyrinth[r][c]}] "
        end
        output += "\n"
      end
      output
    end

    def add_monster(row, col, monster)
      if(empty_pos(row, col))
        @labyrinth[row][col] = @@MONSTER_CHAR
        @monsters[row][col] = monster
        monster.set_pos(row, col)
      end
    end

    def put_player(direction, player)
      old_row = player.row
      old_col = player.col

      new_pos = dir_2_pos(old_row, old_col, direction)
      put_player_2D(old_row, old_col, new_pos[@@ROW], new_pos[@@COL], player)
    end

    def add_block(orientation, start_row, start_col, length)
      if orientation == Orientation::VERTICAL
        inc_row = 1
        inc_col = 0
      else
        inc_row = 0
        inc_col = 1
      end

      row = start_row
      col = start_col

      while pos_OK(row,col) && empty_pos(row,col) && length > 0
        @labyrinth[row][col] = @@BLOCK_CHAR
        length -= 1
        row += inc_row
        col += inc_col
      end
    end

    def valid_moves(row, col)
      output = []

      if can_step_on(row + 1, col)
        output.push(Directions::DOWN)
      end
      if can_step_on(row - 1, col)
        output.push(Directions::UP)
      end
      if can_step_on(row, col + 1)
        output.push(Directions::RIGHT)
      end
      if can_step_on(row, col - 1)
        output.push(Directions::LEFT)
      end

      output
    end

    def pos_OK(row, col)
      row < @n_rows && row >= 0 && col < @n_cols && col >= 0
    end

    def empty_pos(row, col)
      pos_OK(row, col) && @labyrinth[row][col] == @@EMPTY_CHAR
    end

    def monster_pos(row, col)
      pos_OK(row, col) && @labyrinth[row][col] == @@MONSTER_CHAR
    end

    def exit_pos(row, col)
      pos_OK(row, col) && @labyrinth[row][col] == @@EXIT_CHAR
    end

    def combat_pos(row, col)
      pos_OK(row, col) && @labyrinth[row][col] == @@COMBAT_CHAR
    end

    def can_step_on(row, col)
      pos_OK(row, col) && (empty_pos(row, col) || monster_pos(row, col) || exit_pos(row, col))
    end

    def update_old_pos(row, col)
      if pos_OK(row, col)
        if combat_pos(row, col)
          @labyrinth[row][col] = @@MONSTER_CHAR
        else
          @labyrinth[row][col] = @@EMPTY_CHAR
        end
      end
    end

    def dir_2_pos(row, col, direction)
      new_row = row
      new_col = col

      case direction
        when Directions::UP
          new_row -= 1
        when Directions::DOWN
          new_row += 1
        when Directions::LEFT
          new_col -= 1
        when Directions::RIGHT
          new_col += 1
      end

      [new_row, new_col]
    end

    def random_empty_pos
      row = Dice.random_pos(@n_rows)
      col = Dice.random_pos(@n_cols)

      while !empty_pos(row, col)
        row = Dice.random_pos(@n_rows)
        col = Dice.random_pos(@n_cols)
      end

      [row,col]
    end

    def put_player_2D(old_row, old_col, row, col, player)
      output = nil

      if can_step_on(row,col)
        if pos_OK(old_row, old_col)
          p = @players[old_row][old_col]
          if p == player
            update_old_pos(old_row, old_col)
            @players[old_row][old_col] = nil
          end
        end

        if monster_pos(row, col)
          @labyrinth[row][col] = @@COMBAT_CHAR
          output = @monsters[row][col]
        end

        @players[row][col] = player
        player.set_pos(row, col)
      end

      output
    end

  end
end