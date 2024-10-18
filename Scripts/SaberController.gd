extends XRController3D
class_name SaberController

@export var laser: LaserPointer
@export var laserLength: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_instance_valid(laser):
		laser = $LaserPointer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	laser.PointTowards(position - (transform.basis.z) * laserLength)
	#if get_input("ax_button"):
	#	laser.set_process(false)
