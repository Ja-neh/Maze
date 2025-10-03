class_name RecursiveBacktracker

const BOUNDRY := 1
const SPACE := 0
const WALL := 2

const UP_SPACE := -2
const DOWN_SPACE := 2
const LEFT_SPACE := -2
const RIGHT_SPACE := 2

const UP_WALL := -1
const DOWN_WALL := 1
const LEFT_WALL := -1
const RIGHT_WALL := 1

const BOUNDRY_OUTERWALL := 1 #Accounting for boundry and outer wall
const BOUNDRY_ONLY := 0
const MAX_VISITS_PER_BLOCK := 2 #Recursive backtracker visits each block twice

var _column : int
var _row : int
var maze : Array 
var SPACE_blocks : Array
var WALL_blocks : Array


func _init(column : int , row : int) -> void:
	if column % 2 == 0:
		_column = column + 1
	if row % 2 == 0:
		_row = row + 1

	#Adding the boundry, walls and spaces to make the grid for maze
	for c in range(_column):
		var row_array = []
		for r in range(_row):
			var block : Block
			if(r==0 or c==0 or r==_row-1 or c==_column-1):
				row_array.append(BOUNDRY)
			elif(r % 2 == 1 or c % 2 == 1):
				row_array.append(WALL)
			else:
				row_array.append(SPACE)
				#Creating Block instance for a SPACE
				block = Block.new(c, r)
				SPACE_blocks.append(block)
		maze.append(row_array)
		
	#Adding neighbours for each SPACE
	for block in SPACE_blocks:
		_add_neighbours_SPACE(block)


func _add_neighbours_SPACE(block : Block):
	var block_column = block.b_column
	var block_row = block.b_row
	var neighbour : Block
	
	var down = block_column + DOWN_SPACE
	if down < _column - BOUNDRY_OUTERWALL:
		neighbour = _get_block_SPACE(down , block_row)
		if neighbour:
			block._add_neighbour(neighbour)
		
	var up = block_column + UP_SPACE
	if up > BOUNDRY_OUTERWALL:
		neighbour = _get_block_SPACE(up , block_row)
		if neighbour:
			block._add_neighbour(neighbour)
		
	var right = block_row + RIGHT_SPACE
	if right < _row - BOUNDRY_OUTERWALL:
		neighbour = _get_block_SPACE(block_column , right)
		if neighbour:
			block._add_neighbour(neighbour)
		
	var left = block_row + LEFT_SPACE
	if left > BOUNDRY_OUTERWALL:
		neighbour = _get_block_SPACE(block_column , left)
		if neighbour:
			block._add_neighbour(neighbour)


func _add_neighbours_WALL(block : Block):
	var block_column = block.b_column
	var block_row = block.b_row
	var neighbour : Block
	
	var down = block_column + DOWN_WALL
	if down < _column - BOUNDRY_ONLY:
		neighbour = _get_block_WALL(down , block_row)
		if neighbour:
			block._add_neighbour(neighbour)
		
	var up = block_column + UP_WALL
	if up > BOUNDRY_ONLY:
		neighbour = _get_block_WALL(up , block_row)
		if neighbour:
			block._add_neighbour(neighbour)
		
	var right = block_row + RIGHT_WALL
	if right < _row - BOUNDRY_ONLY:
		neighbour = _get_block_WALL(block_column , right)
		if neighbour:
			block._add_neighbour(neighbour)
		
	var left = block_row + LEFT_WALL
	if left > BOUNDRY_ONLY:
		neighbour = _get_block_WALL(block_column , left)
		if neighbour:
			block._add_neighbour(neighbour)


func _get_block_SPACE(column : int , row : int):
	for block in SPACE_blocks:
		if(block.b_column == column and block.b_row == row):
			return block


func _get_block_WALL(column : int , row : int):
	for block in WALL_blocks:
		if(block.b_column == column and block.b_row == row):
			return block


func generate():
	#starting block
	var current_block = SPACE_blocks.pick_random()
	var stack : Array = [current_block]
	
	while not stack.is_empty():
		var current_block_column = current_block.b_column
		var current_block_row = current_block.b_row
		current_block.num_visits += 1
		
		if (current_block.visitable_neighbours).size() > 0:
			var num_neighbours = (current_block.visitable_neighbours).size()
			
			var next_block = (current_block.visitable_neighbours).pick_random()
	
			if next_block.b_column > current_block_column:
				maze[current_block_column + 1][ current_block_row] = SPACE
			elif(next_block.b_column < current_block_column):
				maze[current_block_column - 1][ current_block_row] = SPACE
			elif(next_block.b_row > current_block_row):
				maze[current_block_column][ current_block_row + 1] = SPACE
			else:
				maze[current_block_column][ current_block_row - 1] = SPACE
	
			if current_block.num_visits < MAX_VISITS_PER_BLOCK:
				for neighbour in current_block.neighbours:
					if (neighbour.visitable_neighbours).has(current_block):
						(neighbour.visitable_neighbours).erase(current_block)
			(current_block.visitable_neighbours).erase(next_block)
			
			stack.append(next_block)
			current_block = next_block
			
		else:
			if current_block.num_visits < MAX_VISITS_PER_BLOCK:
				for neighbour in current_block.neighbours:
					if (neighbour.visitable_neighbours).has(current_block):
						(neighbour.visitable_neighbours).erase(current_block)
						
			stack.pop_back()
			if not stack.is_empty():
				current_block = stack.back()
				
	return maze
