extends Node3D
class_name NoteBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.z += 0.4 * delta
	
	if position.z > 4:
		queue_free()