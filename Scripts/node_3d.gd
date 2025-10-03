extends Node3D

@export var wall_scene = preload("res://Scenes/block2.tscn")

const CELL_SIZE := 3  # instead of 1 unit per block

var RB : RecursiveBacktracker
var maze : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RB = RecursiveBacktracker.new(30, 30)
	maze = RB.generate()
	draw_maze()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func draw_maze():
	var wall 
	for c in maze.size():
		for r in maze[c].size():
			if maze[c][r] == RecursiveBacktracker.WALL:
				wall = wall_scene.instantiate()
				wall.position = Vector3(r * CELL_SIZE, 2, c * CELL_SIZE)	# y=1 because block is 2m high
				add_child(wall)
				
				var block = Block.new(c, r)
				(RB.WALL_blocks).append(block)
				
	#Working towards walls to compensate for doubling size
	for block in RB.WALL_blocks:
		RB._add_neighbours_WALL(block)
				
	for block in RB.WALL_blocks:
		var current_block = block
		var current_block_column = current_block.b_column
		var current_block_row = current_block.b_row
		
		for neighbour in block.visitable_neighbours:
			var neighbour_column = neighbour.b_column
			var neighbour_row = neighbour.b_row
					
					
			var fill_column = 2*current_block_column + neighbour_column
			var	fill_row = 2*current_block_row + neighbour_row
			
			var fill_column1 = current_block_column + 2*neighbour_column
			var fill_row1 = current_block_row + 2*neighbour_row
							
			wall = wall_scene.instantiate()
			wall.position = Vector3(fill_row, 2, fill_column)
			add_child(wall)
			wall = wall_scene.instantiate()
			wall.position = Vector3(fill_row1, 2, fill_column1)
			add_child(wall)
			
			if(neighbour.visitable_neighbours).has(current_block):
				(neighbour.visitable_neighbours).erase(current_block)
