extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		position.x += 10
	if Input.is_action_pressed("move_left"):
		position.x -= 10
	if Input.is_action_pressed("move_down"):
		position.y += 10
	if Input.is_action_pressed("move_up"):
		position.y -= 10
