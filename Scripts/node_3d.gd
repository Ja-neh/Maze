extends Node3D

@export var wall_scene = preload("res://Scenes/block2.tscn")
@export var floor_scene = preload("res://Scenes/big.tscn")
@export var floor_gap_scene = preload("res://Scenes/small.tscn")
@export var spikes_scene = preload("res://Scenes/spikes_trap.tscn")

const CELL_SIZE := 3  # instead of 1 unit per block

var RB : RecursiveBacktracker
var columns: int
var rows: int
var maze : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rows = 30
	columns = 30
	RB = RecursiveBacktracker.new(rows, columns)
	maze = RB.generate()
	draw_maze()
	draw_floor()
	

func draw_maze():
	var wall 
	for c in maze.size():
		for r in maze[c].size():
			if maze[c][r] == RecursiveBacktracker.WALL:
				wall = wall_scene.instantiate()
				wall.position = Vector3(r * CELL_SIZE, 1.5, c * CELL_SIZE)	# y=1 because block is 2m high
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
			wall.position = Vector3(fill_row, 1.5, fill_column)
			add_child(wall)
			wall = wall_scene.instantiate()
			wall.position = Vector3(fill_row1, 1.5, fill_column1)
			add_child(wall)
			
			if(neighbour.visitable_neighbours).has(current_block):
				(neighbour.visitable_neighbours).erase(current_block)


func draw_floor():
	var floor_space
	var spikes
	var c_limit = columns / 2
	var r_limit = rows / 2
	for c in range(1, c_limit):
		for r in range(1, r_limit):
			var chance = randi_range(0, 10)
			if chance < 2:
				spikes = spikes_scene.instantiate()
				spikes.position = Vector3(6 * r, 0, 6 * c)
				add_child(spikes)
			else:
				floor_space = floor_scene.instantiate()
				floor_space.position = Vector3(6 * r, 0, 6 * c)
				add_child(floor_space)
			
	for c in range(1, c_limit):
		for r in range(1, r_limit):
			floor_space = floor_gap_scene.instantiate()
			floor_space.position = Vector3(9 + 6 * (r - 1), 0, 6 * c)
			add_child(floor_space)
			
			floor_space = floor_gap_scene.instantiate()
			floor_space.rotation = Vector3(0, - PI/2, 0)
			floor_space.position = Vector3(6 * r, 0, 9 + 6 * (c - 1))
			add_child(floor_space)
			
