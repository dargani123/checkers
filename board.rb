require './piece.rb'
require 'colorize'

class Board 
	attr_accessor :grid

	def initialize(grid=nil)
		if grid.nil?
			@grid = Array.new(8) { [nil] * 8 }
			make_starting_board
		else 
			@grid = grid
		end
	end 

	def next_in_dir(from_loc, to_loc)
		row = from_loc[0] + 2 * (to_loc[0] - from_loc[0])
		col = from_loc[1] + 2 * (to_loc[1] - from_loc[1]) 
		[row, col]
	end 

	def at(position)
		@grid[position[0]][position[1]]
	end 

	def set(position, value)
		@grid[position[0]][position[1]] = value
	end

	def in_bounds(location)
		location[0] >= 0 && location[0] <= 7 && location[1] >= 0 && location[1] <= 7
	end 

	def move(path, player_color) 
		if valid_move?(path, player_color)
			0.upto(path.size-2) { |i| make_move(path[i], path[i+1])}
		else 
			raise "Invalid Move"
		end
	end 

	def valid_move?(path, player_color)
		right_color = at(path[0]).color == player_color
		legal_move = (at(path[0]).possible_moves.include?(path[1]) && path.length == 2) || (path.length > 2 && validPath?(path)) 
		right_color && legal_move
	end 

	def make_move(start, fin) ## represent positions 
		at(start).curr_pos = fin

		set(fin, at(start))
		set(start, nil)

		at(fin).to_king if at(fin).color == :white && fin[0] == 0 
		at(fin).to_king if at(fin).color == :black && fin[0] == 7

		if (fin[1] - start[1]).abs == 2	
			row_to_del, col_to_del = (start[0] + fin[0]) / 2, (start[1] + fin[1]) / 2
			grid[row_to_del][col_to_del] = nil
		end 
	end 

	def validPath?(path)
		test_board = self.dup 
		0.upto(path.size-2) do |i|
			return false unless test_board.at(path[i]).jump_moves(move).include?(path[i+1]) 
			test_board.make_move(move, path[i+1])
		end 
		return true
	end 

	def dup 
		new_board = Board.new(Array.new(8) { [nil] * 8 })
		@grid.each_with_index do |row, i|
			row.each_with_index do |piece, j|
				new_board.set([i,j], piece.dup(new_board)) unless piece.nil?
			end 
		end 
		new_board
	end 

	def win? 
		exists = {:white => 0, :black => 0}
		grid.each{|row| row.each {|piece| exists[piece.color] += 1 unless piece.nil?}}
		exists[:white] == 0 || exists[:black] == 0
	end 

	def make_starting_board
		[0, 1, 6, 7].each do |row|
			@grid[row].size.times do |i|
				color = [6,7].include?(row) ? :white : :black 
				mod_adjust = row.even? ? 0 : 1
				set([row,i], Piece.new(self, color, false, [row, i])) if (i + mod_adjust) % 2 == 0
			end 
		end
	end
end 

class HumanPlayer

	def initialize (color)
		@color = color
	end 

	def play_turn(board)	
		puts "Enter your move: " 
		path = path_format(gets.chomp)
		board.move(path, @color) 
	end 


	def path_format (path_string)
		path = path_string.split(",")	
		path.map! do |move|
			move.split(" ").map!(&:to_i)
		end 
	end 

end 

class Game

	def initialize
		@board = Board.new 
		@players = {:white => HumanPlayer.new(:white), :black => HumanPlayer.new(:black)}
		@current_player = :white
	end 

	def play  
		while true 
			begin
				print_board
				@players[@current_player].play_turn(@board)
			rescue StandardError => e	
				puts e if e.to_s == "Invalid Move"
			else
				@current_player = (@current_player == :white) ? :black : :white
			end 
		break if @board.win? 
		end 
	end 

	def print_board 
		color1, color2  = :yellow, :blue
		@board.grid.each_with_index do |row, j|
			print "#{j}: "
			row.each_with_index do |piece, i| 
				char = piece.nil? ? "   " : " * ".colorize(:color => piece.color)
				print "#{(i + 4) % 2 == 0 ? char.colorize(:background => color1) : char.colorize(:background => color2)}"	
			end 	  	
			color1, color2 = (color1 == :yellow) ? [:blue, :yellow] : [:yellow, :blue]
			puts
		end 
	end 

end

Game.new.play

