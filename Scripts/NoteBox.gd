extends Node3D
class_name NoteBox

var killTimer: float = INF

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	killTimer -= delta
	if killTimer <= 0:
		queue_free()

func DoGibs() -> void:
	$Vis.set_process_mode(Node.PROCESS_MODE_DISABLED)
	$Vis.hide()
	$Gibs.set_process_mode(Node.PROCESS_MODE_INHERIT)
	$Gibs.show()
	
	killTimer = 1.0
