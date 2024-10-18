extends Node

@export var pscene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	"""var instantiated = pscene.instantiate()
	
	var rigidbody = instantiated as RigidBody3D
	rigidbody.global_position = global_position
	rigidbody.rotation = rotation
	
	var direction = -basis.z
	rigidbody.apply_impulse(direction * 5)
	
	get_tree().current_scene.add_child(instantiated)"""
