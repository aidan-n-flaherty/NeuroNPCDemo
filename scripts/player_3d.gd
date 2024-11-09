extends CharacterBody3D

@export var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement = speed * input_dir.normalized()
	movement.y *= -1
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = speed
	
	if Input.is_action_just_released("run"):
		movement.x *= 30
		movement.y *= 30
	
	velocity.x = 0.9 * velocity.x + 0.1 * -movement.x
	velocity.z = 0.9 * velocity.z + 0.1 * movement.y
	
	if velocity.z != 0 or velocity.x != 0:
		rotation.y = -atan2(velocity.z, velocity.x)
	
	move_and_slide()
