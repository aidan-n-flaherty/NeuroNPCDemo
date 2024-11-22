extends CharacterBody2D

var speed = 300

var timeout = -1

var speechBubble = null

func _process(delta: float) -> void:
	if Input.is_action_just_released("open_chat") and not speechBubble:
		var node = preload("res://scenes/3D/SpeechBubble.tscn").instantiate()
		node.init(true)
		node.sendMessage.connect(displaySpeechBubble)
		add_child(node)
		
		speechBubble = node
	
	if timeout > 0:
		timeout -= delta
		
		if not timeout > 0:
			remove_child(speechBubble)
			speechBubble = null

func displaySpeechBubble(text: String):
	var action = Action.new()
	action.init('say', [text])
	$Brain.emitAction(action)
	
	if speechBubble:
		remove_child(speechBubble)
		speechBubble = null
	
	var node = preload("res://scenes/3D/SpeechBubble.tscn").instantiate()
	node.init(false, text, true)
	add_child(node)
	
	speechBubble = node
	
	timeout = 2 + int(len(text) / 10)

func _physics_process(delta: float) -> void:	
	var suppress = speechBubble and speechBubble.isEditing()
	
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
	velocity = velocity * speed if not suppress else Vector2()
	move_and_slide()
	
	# Interact with Bartender
	# if Input.is_action_pressed("interact") and $"bartender":
		
	
	
	
	
	
	
	
	
	
	
	
