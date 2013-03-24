class Piece 

	attr_accessor :color, :curr_pos, :king

	def initialize (board, color, king, position = nil) #REV: Hm, 
		@board, @color, @curr_pos, @king = board, color, position, king
	end 

	def possible_moves(start=@curr_pos)
		jump = jump_moves(start)
		moves = (potential_moves(start) - jump).select { |move| @board.at(move).nil? } 
		moves | jump
	end 

	def jump_moves (start=@curr_pos) #REV: What is going on, possible_moves, jump_moves, potential_moves? what.
		moves = []
		potential_moves.each do |move|
			next if @board.at(move).nil?
			if @board.at(move).color != color && @board.at(@board.next_in_dir(start, move)).nil? 
				moves += [@board.next_in_dir(start, move)]
			end
		end 
		moves 
	end 

	def sub_paths(path)
		all_sub_paths = [] 
		(path.size - 2).downto(0) do |index|
			all_sub_paths << path[0..index]
		end 
		all_sub_paths
	end 

	def directions
		return [-1,1] if @king 
		return (color == :white) ? [-1] : [1]
	end 

	def potential_moves (start=@curr_pos) 
		pot_moves = []
		directions.each do |direction|
			first, second = [start[0] + direction, start[1] + 1], [start[0] + direction, start[1] - 1]
			pot_moves << first if @board.in_bounds(first)
			pot_moves << second if @board.in_bounds(second)
		end 
		pot_moves 
	end 

	def display 
		letter = (color == :white) ? "w" : "r" #REV: What's this? Don't you use * for the piece display?
		@king ? letter.upcase : letter
	end 

	def to_king #REV: I made King a subclass of Piece with it's own symbol.
		@king = true
	end 

	def dup(board)
		Piece.new(board, color, @king, curr_pos)
	end 

end 