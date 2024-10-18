extends Node
class_name CubeSpawner

@export var noteboxPrefab: PackedScene
@export var noteboxSpeed = 2.0
@export var noteboxRandomDelay = Vector2(0.5, 2.0)
var goalTime: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# https://github.com/godotengine/godot-proposals/issues/1731#issuecomment-2326160890
func random_direction() -> Vector3:
	var theta := randf() * TAU
	var phi := acos(2.0 * randf() - 1.0)
	var sin_phi := sin(phi)
	return Vector3(cos(theta) * sin_phi, sin(theta) * sin_phi, cos(phi))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var curTime = Time.get_ticks_msec() / 1000.0
	
	if curTime > goalTime:
		#print("Spawning new cube? ", curTime)
		# set goal time for next note
		goalTime = curTime + randf_range(noteboxRandomDelay.x, noteboxRandomDelay.y)
		
		var instantiated = noteboxPrefab.instantiate()
	
		var note = instantiated as NoteBox
		var randDir = random_direction() * 0.25
		#randDir.z = 0
		note.global_position = Vector3(0, 1.1, -5) + randDir
		
		#get_tree().current_scene.add_child(instantiated)
		add_child(instantiated)
	
	for thingy in get_children():
		if thingy is not NoteBox:
			continue
		
		thingy.position.z += noteboxSpeed * delta
		if thingy.position.z > 4:
			thingy.queue_free()
