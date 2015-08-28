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

  def [](pos)
    x,y = pos
    return board[x][y]
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
        pos = gets.chomp.split(",").map { |el| Integer(el)}
        board[pos].reveal


      when 2
        puts "Which flag would you like to reveal? Ex) x,y"
        pos = gets.chomp.split(",").map { |el| Integer(el)}
    end
  end

  def game_over

  end

end

class Tile
  attr_reader :board, :bomb
  attr_accessor :pos, :flag, :display
  def initialize(board,bomb)
    @board = board
    @pos = nil
    @bomb = bomb
    @flag = false
    @display = "*"
  end
=begin
  def inspect
    "position: #{position}"
    "bombed?   #{bombed?}"
    "flagged?  #{flagged?}"
    "state?    #{revealed?}"
  end
=end

  def flagged?
    @flag
  end
  def revealed?
  end

  def reveal
    board.game_over if board[pos].bomb

    if neighbors.all? { |tile| !tile.bomb }
      #all neighbors do not contain a bomb
      #reveal that this is an empty tile
      self.display = " "
      neighbors.each do |neighbor|
        neighbor.reveal
      end
    else
      #at least one of its neighbors contain a bomb
      self.display = neighbor_bomb_count.to_s
      #display number on tile
    end


  end

  # returns array of neighbors
  def neighbors
    next_to = [[-1,0],[-1,1],[0,1],[1,1],
              [1,0],[1,-1],[0,-1],[-1,-1]]

   pos_neighbors = []
   next_to.each do |move|
     tmp = [pos[0] + move[0], pos[1] + move[1]]
     pos_neighbors << tmp if valid_position(tmp)
   end

   pos_neighbors
  end

  def valid_position?
    row = pos[0]
    col = pos[1]
    return true if (0..8).include?(row) && (0..8).include?(col)

    false
  end


  def neighbor_bomb_count
    count = 0
    neighbors.each do |neighbor|
      count += 1 if neighbor.bomb
    end
    count
  end

end
