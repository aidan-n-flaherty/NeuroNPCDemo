extends CharacterBody2D

var speed = 300

func _physics_process(delta: float) -> void:	
	
	# Run 
	if Input.is_action_pressed("run"):
		speed = 600
	else:
		speed = 300
	
	# Horizontal Movement
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	elif Input.is_action_pressed("move_left"):
		velocity.x = -1
	else:
		velocity.x = 0
		
	# Vertical Movement
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
	elif Input.is_action_pressed("move_up"):
		velocity.y = -1
	else:
		velocity.y = 0
	
	# Apply Movement and Collisions
	velocity = velocity * speed
	move_and_slide()
	

func spawn(start_pos):
	global_position = start_pos
