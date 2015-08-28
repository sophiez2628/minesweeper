class Board
  BOMB_COUNT = 10
  TILE_COUNT = 81
  attr_reader :board

  def initialize
    @board = Array.new(9) {Array.new(9)}
  end

  def populate
    # make 10 bombs
    puts "boo"
    tiles = Array.new(BOMB_COUNT) { Tile.new(board,true)}
    # Add tiles for the rest of the board
    (TILE_COUNT - BOMB_COUNT).times { tiles << Tile.new(board, false)}
    # 81 shuffled tiles
    tiles.shuffle!
    #fill board
    board.each_with_index do |row, row_idx|
      row.each_with_index do |el, el_idx|
        temp_tile = tiles.shift
        temp_tile.position = [row_idx, el_idx]
        board[row_idx][el_idx] = temp_tile
      end
    end
  end

  def print_board
    board.each_with_index do |row, row_idx|
      row.each_with_index do |el, el_idx|
        puts board[row_idx][el_idx]
      end
    end
  end

  def [](coord)
    x,y = coord
  end

end

class Minesweeper
  attr_reader :board

  def initialize
    @board = Board.new
    @board.populate
  end
puts dsfasdf puts
  def play
    puts "Do you want to reveal(1) or flag a tile(2)?"
    user_choice = gets.chomp.to_i
    case user_choice
      when 1
        #reveal
        puts "Which tile would you like to reveal? Ex) x,y"
        coord = gets.chomp.split(",").map { |el| Integer(el)}

        board[coord.first, coord.last]

      when 2
        puts "Which flag would you like to reveal? Ex) x,y"
        coord = gets.chomp.split(",").map { |el| Integer(el)}
    end
  end

end

class Tile
  attr_reader :board,
  attr_accessor :position, :flag
  def initialize(board,bomb)
    @board = board
    @position = nil
    @bomb = bomb
    @flag = false
  end
=begin
  def inspect
    "position: #{position}"
    "bombed?   #{bombed?}"
    "flagged?  #{flagged?}"
    "state?    #{revealed?}"
  end
=end
  def bombed?

  end
  def flagged?
    @flag
  end
  def revealed?
  end

  def reveal
  end

  def neighbors
  end

  def neighbor_bomb_count
  end

end
