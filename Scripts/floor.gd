@tool
extends EditorScript

@export var floor_scene = preload("res://Scenes/grass_block.tscn")
@export var floor_gap_scene = preload("res://Scenes/small.tscn")

var columns: int
var rows: int

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	columns = 30
	rows = 30
	draw_floor()
	
	
func draw_floor():
	var children : Array = get_editor_interface().get_selection().get_selected_nodes()[0].get_children()
	
	var floor : Node3D
	for child in children:
		if child.name == "floor":
			floor = child
			break
			
	for child in floor.get_children():
		floor.remove_child(child)
		child.queue_free()

	
	var floor_space
	var c_limit = columns / 2
	var r_limit = rows / 2
	for c in range(1, c_limit):
		for r in range(1, r_limit):
			floor_space = floor_scene.instantiate()
			floor_space.position = Vector3(6 * r, 0, 6 * c)
			floor.add_child(floor_space)
			floor_space.set_owner(floor.get_tree().get_edited_scene_root())
			
	for c in range(1, c_limit):
		for r in range(1, r_limit):
			floor_space = floor_gap_scene.instantiate()
			floor_space.position = Vector3(9 + 6 * (r - 1), 0, 6 * c)
			floor.add_child(floor_space)
			floor_space.set_owner(floor.get_tree().get_edited_scene_root())
			
			floor_space = floor_gap_scene.instantiate()
			floor_space.rotation = Vector3(0, - PI/2, 0)
			floor_space.position = Vector3(6 * r, 0, 9 + 6 * (c - 1))
			floor.add_child(floor_space)
			floor_space.set_owner(floor.get_tree().get_edited_scene_root())
	
