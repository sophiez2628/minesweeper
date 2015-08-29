require 'byebug'
require 'yaml'
require 'colorize'


class Board
  BOMB_COUNT = 10
  TILE_COUNT = 81
  attr_reader :grid

  def initialize
    @grid = Array.new(9) {Array.new(9)}
  end

  def populate
    # make 10 bombs
    tiles = Array.new(BOMB_COUNT) { Tile.new(self, true)}
    # Add tiles for the rest of the grid
    (TILE_COUNT - BOMB_COUNT).times { tiles << Tile.new(self, false)}
    # 81 shuffled tiles
    tiles.shuffle!

    #fill grid
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |el, el_idx|
        temp_tile = tiles.shift
        temp_tile.pos = [row_idx, el_idx]
        grid[row_idx][el_idx] = temp_tile
      end
    end

  end

  def print_board
    puts "    0   1   2   3   4   5   6   7   8".colorize(:magenta)
    grid.each_with_index do |row, row_idx|
      print "#{row_idx} | ".colorize(:magenta)
      row.each do |tile|
        print tile.inspect + " | "
      end
      puts ""
    end
  end


  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def game_loss
    grid.each do |row|
      row.each do |tile|
        tile.display = "B".colorize(:yellow) if tile.bomb
      end
    end
    print_grid
    abort("Game over! You lose!")
  end

  def won?
    #get all tiles, get all non-revealed, check if they are all bombs
    grid.flatten.select { |tile| !tile.revealed?}.all? { |tile| tile.bomb}
  end

end

class Minesweeper
  attr_reader :board

  def initialize
    @board = Board.new
    @board.populate
    play
  end

  def play
    until board.won?
      board.print_board
      turn
    end
    puts "Congratulations, you win!"
  end

  def turn
    user_choice = 0
    until user_choice == 1 || user_choice == 2
      puts "Do you want to reveal(1) or flag a tile(2) or save current game(3)?"
      user_choice = gets.chomp.to_i
      case user_choice
        when 1
          # reveal
          puts "Which tile would you like to reveal? Ex) x,y"
          pos = gets.chomp.split(",").map { |el| Integer(el)}
          board[pos].reveal
        when 2
          #set flag
          puts "Which flag would you like to reveal? Ex) x,y"
          pos = gets.chomp.split(",").map { |el| Integer(el)}
          board[pos].set_flag
        when 3
          save
      end
    end
  end

  def save
    File.open("current_game.txt", "w") do |file|
      file.puts self.to_yaml
    end

    abort("Game saved to current_game.txt")

  end
end

class Tile
  attr_reader :board, :bomb
  attr_accessor :pos, :flag, :display, :revealed
  def initialize(board,bomb)
    @board = board
    @pos = nil
    @bomb = bomb
    @flag = false
    @display = "*".colorize(:blue)
    @revealed = false
  end

  def inspect
    self.display
  end

  def set_flag
    if board[pos].flagged?
      self.flag = false
      self.display = "*".colorize(:blue)
    else
      self.flag = true
      self.display = "F".colorize(:red)
    end
  end

  def flagged?
    @flag
  end
  def revealed?
    @revealed
  end

  def reveal
    board.game_loss if board[pos].bomb

    if neighbors.all? { |position| !board[position].bomb }
      #all neighbors do not contain a bomb
      #show that this is an empty tile
      self.display = "_"
      self.revealed = true
      neighbors.each do |position|
        board[position].reveal
      end
    else
      #at least one of its neighbors contain a bomb
      #display number on tile
      self.revealed = true
      self.display = neighbor_bomb_count.to_s
    end


  end

  # returns array of neighbors
  def neighbors
    next_to = [[-1,0],[-1,1],[0,1],[1,1],
              [1,0],[1,-1],[0,-1],[-1,-1]]

   pos_neighbors = []
   next_to.each do |move|
     tmp = [pos[0] + move[0], pos[1] + move[1]]
     #grabbing possible neighbors if on board, unrevealed, and not flagged
     pos_neighbors << tmp if valid_position?(tmp) && !board[tmp].revealed? && !board[tmp].flagged?
   end

   pos_neighbors
  end

  def valid_position?(neighbor)
    row = neighbor[0]
    col = neighbor[1]
    return true if (0..8).include?(row) && (0..8).include?(col)

    false
  end


  def neighbor_bomb_count
    count = 0
    neighbors.each do |position|
      count += 1 if board[position].bomb
    end
    count
  end

end

if __FILE__ == $PROGRAM_NAME
  if ARGV[0]
    YAML.load_file(ARGV.shift).play
  else
    game = Minesweeper.new
    game.play
  end
end
