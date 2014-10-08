require_relative "LIChess"

def start
  puts "\nDo you want to play the LIChess Daily Challenge (Y/N)"
  response = gets.chomp.upcase
  if response == "Y"
    LIChessGame.new.setup_board.play
  else
    puts "\nEnter name 1: "
    name1 = gets.chomp
    puts "\nEnter name2: "
    name2 = gets.chomp

    puts "\nWelcome to Chess!"
    Game.new(name1, name2).play
  end
end

start