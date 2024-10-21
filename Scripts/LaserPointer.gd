extends Node3D
class_name LaserPointer
signal laser_entered_area(area: Area3D, strikeDir: Vector3)

# Expects to be set up like so:
# LaserPointer
# - Cylinder/quad shape
# - Area3D
#   - CollisionShape3D

@export var color = Color(1, 0, 0, 1)
# Distance threshold at which strike direction is set to zero
@export var strikeDirNoiseThreshold: float = 0.04

var lastBase: Vector3
var lastTip: Vector3

#var debugCubes: Array[CSGBox3D] = [null, null, null, null]

func _ready() -> void:
	SetColor(color)

func _process(delta: float) -> void:
	#UpdateDebugCubes()
	
	lastBase = global_position
	lastTip = global_position + (-global_transform.basis.z)
	
func SetColor(col: Color) -> void:
	if is_instance_valid($DisplayMesh.material_override):
		# gotta duplicate it! no per-instance variables here (only applies to global uniforms :( )
		$DisplayMesh.material_override = $DisplayMesh.material_override.duplicate()
		var trans = col
		trans.a = 0.5
		$DisplayMesh.material_override.albedo_color = trans
		$DisplayMesh.material_override.emission = col

#func UpdateDebugCubes() -> void:
	#for i in debugCubes.size():
		#if !is_instance_valid(debugCubes[i]):
			#var cubeBase = CSGBox3D.new()
			#cubeBase.size = Vector3(0.05, 0.05, 0.05)
			#get_tree().current_scene.add_child(cubeBase)
			#debugCubes[i] = cubeBase
	#
	#debugCubes[0].global_position = global_position
	#debugCubes[1].global_position = global_position + (-global_transform.basis.z)
	#debugCubes[2].global_position = lastBase
	#debugCubes[3].global_position = lastTip
	#
	#var nowTip = global_position + (-global_transform.basis.z)
	#var tipDiff = (nowTip - lastTip)
	#if tipDiff.length() <= strikeDirNoiseThreshold:
		#tipDiff = Vector3.ZERO
	#
	#debugCubes[0].global_position = global_position + (-global_transform.basis.z) + (tipDiff.normalized() * 0.1)
	#
	#debugCubes[0].material = StandardMaterial3D.new()
	#debugCubes[0].material.albedo_color = Color(0, 1, 0, 1) if (tipDiff.normalized()).dot(Vector3.DOWN) > 0.5 else Color(0, 0, 0, 1)

func PointTowards(pointPos: Vector3) -> void:
	var dist = global_position.distance_to(pointPos)
	scale.z = dist
	look_at(pointPos, get_viewport().get_camera_3d().get_global_transform().basis.y)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent() is LaserPointer:
		return
	
	var nowTip = global_position + (-global_transform.basis.z)
	var tipDiff = (nowTip - lastTip)
	if tipDiff.length() <= strikeDirNoiseThreshold:
		tipDiff = Vector3.ZERO
	
	laser_entered_area.emit(area, tipDiff.normalized())
