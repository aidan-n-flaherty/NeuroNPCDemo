extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target = Vector3($Player3D.position.x, $Player3D.position.y + 5, $Player3D.position.z - 5)
	
	$Camera3D.position = 0.95 * $Camera3D.position + 0.05 * target
