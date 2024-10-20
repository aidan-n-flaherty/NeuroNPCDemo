extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		$Sprite2D.position.x += 1
	if Input.is_action_pressed("move_left"):
		$Sprite2D.position.x -= 1
	if Input.is_action_pressed("move_down"):
		$Sprite2D.position.y += 1
	if Input.is_action_pressed("move_up"):
		$Sprite2D.position.y -= 1
