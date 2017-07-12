require "./scrabble.rb"

class Game
  
end

if __FILE__ == $PROGRAM_NAME
  game = Scrabble.new
  p game
  tiles = [["d",7,7], ["r",7,8], ["i",7,9], ["z",7,10], ["z",7,11], ["l",7,12], ["e",7,13]]
  tiles = Scrabble.make_tiles(tiles)
  score = game.play_tiles(tiles)
  p game
  p score #{:valid=>true, :score=>5}

  tiles2 = [["m", 6, 13], ["i", 6, 14]]
  tiles2 = Scrabble.make_tiles(tiles2)
  score = game.play_tiles(tiles2)
  p game
  p score

  tiles3 = [["s",7,14], ["t",8,14]]
  tiles3 = Scrabble.make_tiles(tiles3)
  score = game.play_tiles(tiles3)
  p game
  p score
end
