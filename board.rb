require './piece.rb'
require 'colorize'

class Board 

	def initialize
		@grid = Array.new(8) { [nil] * 8 }

		@grid[6][6] = Piece.new(self, :white, false, [6,6])
		@grid[5][5] = Piece.new(self, :red, false, [5,5])
		@grid[3][3] = Piece.new(self, :red, false, [3,3])
		@grid[1][1] = Piece.new(self, :red, false, [1,1])

		puts "possible moves: #{@grid[6][6].possible_moves}"

	end 

	def next_in_dir(from_loc, to_loc)
		row = from_loc[0] + 2 * (to_loc[0] - from_loc[0])
		col = from_loc[1] + 2 * (to_loc[1] - from_loc[1]) 
		[row, col]
	end 

	def at(position)
		@grid[position[0]][position[1]]
	end 

	def print_board 
		color1 = :red
		color2 = :white
		@grid.each_with_index do |row|
				row.each_with_index do |piece, i| 
				to_print = piece.nil? ? "  " : "#{piece.display} " 
				print to_print.colorize(:color => :black, :background => color1) if i % 2 == 0 
				print to_print.colorize(:color => :black, :background => color2) if i % 2 != 0 
			end 	  	
			color1, color2 = (color1 == :red) ? [:white, :red] : [:red, :white]
			puts
		end 
	end 

	def move(start_loc, path)

	end 


end 


class HumanPlayer

	def initialize (board, color)
		@board = board
		@color 
	end 

	def move
		start_loc = [4,4]
		path = [[2,2], [0,0]]
			
		if @board.at(start_loc).color == @color & @board.at(start_loc).possible_moves.include?(end_loc)
			@board.move(start_loc, path)
		else 
			puts "Invalid Move"
		end 

	end 

end 





Board.new.print_board

