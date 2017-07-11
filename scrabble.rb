require "./dictionary.rb"

LETTERS = [ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
            'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' ]
SCORES  = [ 1,   3,   3,   2,   1,   4,   2,   4,   1,   8,   5,   1,
            3,   1,   1,   3,   10,  1,   1,   1,   1,   4,   4,   8,   4,   10 ]
SCORES_BY_LETTER = Hash[LETTERS.zip(SCORES)] # { 'a': 1, 'b': 3, ... }

def valid_word?(word)
  DICTIONARY.has_key? word
end

class Scrabble

  attr_accessor :board, :first_flag, :score

  def initialize
    @board = create_board
    @first_flag = true
    @score = 0
  end

  def create_board
    Array.new(15) { Array.new(15) }
  end
  # tiles - Array<{ letter: String, row: Int, col: Int }>
  #
  #  an array of hashes; each hash contains a `:letter` (the letter
  #  of the tile to play), a `:row` (the row to play the tile in) and
  #  a `:col` (the column to play the tile in).
  #
  # score - { valid: Boolean, score: Int }
  #
  #  `:valid` is whether or not the set of tiles represent a valid game
  #  move. If so, `:score` is the value of the play to be added to the
  #  score, and if not, `:score` is 0.
  #
  def play_tiles(tiles)
    letters = valid?(tiles)

    if letters.length == 0
      {valid: false, score: 0}
    else
      total = get_score(letters)
      place_tiles(tiles)
      {valid: true, score: total}
    end

  end

  private

  def valid?(tiles)
    return "" if first_flag && (first_play? && !seven_seven(tiles))
    return "" unless unique?(tiles)


    if row?(tiles)
      row_test(tiles)
    elsif column?(tiles)
      col_test(tiles)
    else
      ""
    end
  end

  def get_score(letters)
    total = 0
    letters.split("").each do |letter|
      total += SCORES_BY_LETTER[letter]
    end
    total
  end

  def place_tiles(tiles)
    @first_flag  = false
    tiles.each do |tile|
      row, col = tile[:row], tile[:col]
      board[row][col] = tile[:letter]
    end
  end

  def row?(tiles)
    tiles.all? { |hash| hash[:row] == tiles[0][:row]}
  end

  def column?(tiles)
    tiles.all? { |hash| hash[:col] == tiles[0][:col]}
  end

  def first_play?
    board.flatten.all? { |val| val.nil? }
  end

  def seven_seven(tiles)
    tiles.any? { |hash| hash[:col] == 7 && hash[:row] == 7 }
  end

  def unique?(tiles)
    unique_check = Hash.new
    tiles.each do |tile|
      tester = "#{tile[:row]}#{tile[:col]}"
      return false if unique_check[tester]
      unique_check[tester] = true
    end
    true
  end

  def row_test(tiles)
    row = tiles[0][:row]
    first, last = tiles[0][:col], tiles[-1][:col]
    return "" unless inbounds?(first) && inbounds?(last)

    word = ""
    word_arr = []
    shared_letter = false

    i = 0
    first.upto(last) do |j|
      if tiles[i][:col] != j #gaps in word
        shared_letter = true
        word += board[row][j] #should add test for null later
      else
        return "" if tile_already_exists(tiles[i])

        #check for newly formed words
        check = check_columns(row, j, tiles[i][:letter])
        if check.length > 1
          if valid_word?(check)
            shared_letter = true
            word_arr << check
          else
            return ""
          end
        end

        word += tiles[i][:letter]
        i += 1
      end
    end

    return "" if !shared_letter && !@first_flag
    word = check_right(row, first) + word + check_left(row, last)
    valid_word?(word) ? word + word_arr.join("") : ""
  end

  def col_test(tiles)
    col = tiles[0][:col]
    first, last = tiles[0][:row], tiles[-1][:row]
    return "" unless inbounds?(first) && inbounds?(last)

    word = ""
    word_arr = []
    shared_letter = false

    i = 0
    first.upto(last) do |j|
      if tiles[i][:row] != j #gaps in word
        shared_letter = true
        word += board[j][col]
      else
        return "" if tile_already_exists(tiles[i])

        #check for newly formed words
        check = check_rows(j, col, tiles[i][:letter])
        if check.length > 1
          if valid_word?(check)
            shared_letter = true
            word_arr << check
          else
            return ""
          end
        end

        word += tiles[i][:letter]
        i += 1
      end
    end

    return "" if !shared_letter && !@first_flag
    word = check_up(first, col) + word + check_down(last, col)
    valid_word?(word) ? word + word_arr.join("") : ""
  end

  def inbounds?(num)
    num >= 0 && num <= 14
  end

  def tile_already_exists(tile)
    row, col = tile[:row], tile[:col]
    !board[row][col].nil?
  end

  def check_right(row, col)
    result = ""
    i = col + 1
    while inbounds?(i) && !board[i][col].nil?
      result += board[i][col]
      i += 1
    end
    result
  end

  def check_left(row, col)
    result = ""
    i = col - 1
    while inbounds?(i) && !board[i][col].nil?
      result += board[i][col]
      i -= 1
    end
    result
  end

  def check_up(row, col)
    result = ""
    i = row - 1
    while inbounds?(i) && !board[i][col].nil?
      result += board[i][col]
      i -= 1
    end
    result
  end

  def check_down(row, col)
    result = ""
    i = row + 1
    while inbounds?(i) && !board[i][col].nil?
      result += board[i][col]
      i += 1
    end
    result
    result
  end

  def check_columns(row, col, letter)
    check_up(row, col) + letter + check_down(row, col)
  end

  def check_rows(row, col, letter)
    check_left(row, col) + letter + check_right(row, col)
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Scrabble.new
  p game 
end
