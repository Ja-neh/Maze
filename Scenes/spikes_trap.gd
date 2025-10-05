extends Node3D

@onready var spikes = $AnimatableBody3D
@onready var spikes_animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision_body = spikes.get_child(1)
	
