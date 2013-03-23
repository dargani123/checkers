class Piece 

	attr_accessor :color, :curr_pos 

	def initialize (board, color, king, position = nil)
		@board, @color, @curr_pos, @king = board, color, position, king
	end 

	def possible_moves
		## set directions
		## check if opponents in any direction
		moves = []
		jump = jump_moves(@curr_pos)
		moves = (potential_moves - jump).select { |move| @board.at(move).nil? } 
		moves | jump
		#moves
	end 

	def jump_moves (start)
		moves = []
		potential_moves(start).each do |move|
			path = []
			next if @board.at(move).nil?
			if @board.at(move).color != color && @board.at(@board.next_in_dir(start, move)).nil? 
				path += [@board.next_in_dir(start, move)]
				path << jump_moves(@board.next_in_dir(start, move))
			end
			moves << path
			puts "#{path} path"
			puts "sub paths #{sub_paths(path)}"
			#moves += sub_paths(path) 	
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
			pot_moves << [start[0] + direction, start[1] + 1]
			pot_moves << [start[0] + direction, start[1] - 1]
		end 
		pot_moves 
	end 

	def display 
		letter = (color == :white) ? "w" : "b"
		@king ? letter.upcase : letter
	end 

	def change_king 
		@king = !king
	end 

end 