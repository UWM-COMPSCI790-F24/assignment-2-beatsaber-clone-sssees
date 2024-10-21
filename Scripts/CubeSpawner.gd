extends Node
class_name CubeSpawner

@export var noteboxPrefab: PackedScene
@export var noteboxSpeed = 2.0
@export var noteboxRandomDelay = Vector2(0.5, 2.0)

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
	SpawnRandomCubes()
	
	for child in get_children():
		if child is not NoteBox:
			continue
		
		# For whatever reason, setting the position directly breaks the rigidbody gibs
		# I wish I knew why that happened
		child.Push(Vector3(0, 0, noteboxSpeed * delta))

var goalTime: float = 0.0
func SpawnRandomCubes() -> void:
	var curTime = Time.get_ticks_msec() / 1000.0
	
	if curTime > goalTime:
		#print("Spawning new cube? ", curTime)
		# set goal time for next note
		goalTime = curTime + randf_range(noteboxRandomDelay.x, noteboxRandomDelay.y)
		
		var instantiated = noteboxPrefab.instantiate()
	
		var note = instantiated as NoteBox
		note.ident = randi_range(NoteBox.NoteIdent.Red, NoteBox.NoteIdent.Blue)
		add_child(instantiated)
		
		# position/rotation needs to happen after the node is in the tree
		# (otherwise there's cryptic internal errors)
		var randDir = random_direction() * 0.25
		note.global_position = Vector3(0, 1.1, -5) + randDir
		note.global_rotation_degrees.z = randi_range(0, 3) * 90
