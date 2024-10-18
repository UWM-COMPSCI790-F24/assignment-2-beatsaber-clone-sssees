extends Node3D
class_name LaserPointer
signal laser_entered_area(area: Area3D)

# Expects to be set up like so:
# LaserPointer
# - Cylinder/quad shape
# - Area3D
#   - CollisionShape3D

var lastBase: Vector3
var lastTip: Vector3

var debugCubes: Array[CSGBox3D] = [null, null, null, null]

func _process(delta: float) -> void:
	UpdateDebugCubes()
	
	lastBase = global_position
	lastTip = global_position + (-global_transform.basis.z * scale.z)

func UpdateDebugCubes() -> void:
	for i in debugCubes.size():
		if !is_instance_valid(debugCubes[i]):
			var cubeBase = CSGBox3D.new()
			cubeBase.size = Vector3(0.05, 0.05, 0.05)
			get_tree().current_scene.add_child(cubeBase)
			debugCubes[i] = cubeBase
	
	debugCubes[0].global_position = global_position
	debugCubes[1].global_position = global_position + (-global_transform.basis.z * scale.z)
	debugCubes[2].global_position = lastBase
	debugCubes[3].global_position = lastTip

func PointTowards(pointPos: Vector3) -> void:
	var dist = global_position.distance_to(pointPos)
	scale.z = dist
	look_at(pointPos, get_viewport().get_camera_3d().get_global_transform().basis.y)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent() is LaserPointer:
		return
	
	laser_entered_area.emit(area)
