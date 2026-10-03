extends Node3D

@export var wall_scene = preload("res://Scenes/block2.tscn")
#@export var floor_scene = preload("res://Scenes/big.tscn")
@export var floor_scene = preload("res://Scenes/grass_block.tscn")
@export var floor_gap_scene = preload("res://Scenes/small.tscn")
@export var spikes_scene = preload("res://Scenes/spikes_trap.tscn")
@export var key_scene = preload("res://Scenes/key.tscn")

@onready var player: CharacterBody3D = $Node3D
@onready var camera_aerial: Camera3D = $Camera3D2
var camera_player: Camera3D

const CELL_SIZE := 3  # instead of 1 unit per block

var RB : RecursiveBacktracker
var rows = 30
var columns = 30
var maze : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_aerial.current = true
	
	var player_children = player.get_children()
	for child in player_children:
		if child.name == "TwistPivot":
			camera_player = child.get_child(0).get_child(0)
	
	generate_maze()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch"):
		switch_camera()
			
	if Input.is_action_just_pressed("generate"):
		regenerate_maze()

func switch_camera():
	if camera_aerial.current:
		if camera_player != null:
			camera_player.current = true
	else:
		camera_aerial.current = true

func generate_maze():
	RB = RecursiveBacktracker.new(rows, columns)
	maze = RB.generate()
	draw_maze()
	draw_floor()
	#spawn_keys()
	
func regenerate_maze():
	clear_maze()
	generate_maze()
	player.position.y = 10;

func clear_maze():
	for child in get_tree().get_nodes_in_group("maze_parts"):
		child.queue_free()
		
	await get_tree().process_frame

func draw_maze():
	var wall 
	for c in maze.size():
		for r in maze[c].size():
			if maze[c][r] == RecursiveBacktracker.WALL:
				wall = wall_scene.instantiate()
				wall.add_to_group("maze_parts")
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
			wall.add_to_group("maze_parts")
			wall.position = Vector3(fill_row, 1.5, fill_column)
			add_child(wall)
			wall = wall_scene.instantiate()
			wall.add_to_group("maze_parts")
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
			#if chance < 2:
				#spikes = spikes_scene.instantiate()
				#spikes.add_to_group("maze_parts")
				#spikes.position = Vector3(6 * r, 0, 6 * c)
				#add_child(spikes)
			#else:
			floor_space = floor_scene.instantiate()
			floor_space.add_to_group("maze_parts")
			floor_space.position = Vector3(6 * r, 0, 6 * c)
			add_child(floor_space)
			
	for c in range(1, c_limit):
		for r in range(1, r_limit):
			floor_space = floor_gap_scene.instantiate()
			floor_space.add_to_group("maze_parts")
			floor_space.position = Vector3(9 + 6 * (r - 1), 0, 6 * c)
			add_child(floor_space)
			
			floor_space = floor_gap_scene.instantiate()
			floor_space.add_to_group("maze_parts")
			floor_space.rotation = Vector3(0, - PI/2, 0)
			floor_space.position = Vector3(6 * r, 0, 9 + 6 * (c - 1))
			add_child(floor_space)

func spawn_keys():
	var c_limit = columns / 2
	var r_limit = rows / 2
	for i in range(3):
		var c = randi_range(1, c_limit - 1)
		var r = randi_range(1, r_limit - 1)
		var key = key_scene.instantiate()
		key.add_to_group("maze_parts")
		key.position = Vector3(6 * r, 2, 6 * c)
		add_child(key)

func _on_c_pressed() -> void:
	switch_camera()

func _on_g_pressed() -> void:
	regenerate_maze()
