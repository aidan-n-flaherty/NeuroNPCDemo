extends CharacterBody3D

@export var speed = 5

var speechBubble = null

var timeout = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Brain.init(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	node.init(false, text)
	add_child(node)
	
	speechBubble = node
	
	timeout = 2 + int(len(text) / 10)

func _physics_process(delta: float) -> void:
	var suppress = speechBubble and speechBubble.isEditing()
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement = speed * input_dir.normalized() if not suppress else Vector2()
	movement.y *= -1
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("jump") and is_on_floor() and not suppress:
		print(suppress)
		velocity.y = speed
	
	if Input.is_action_just_released("run"):
		movement.x *= 30
		movement.y *= 30
	
	velocity.x = 0.9 * velocity.x + 0.1 * -movement.x
	velocity.z = 0.9 * velocity.z + 0.1 * movement.y
	
	if velocity.z != 0 or velocity.x != 0:
		rotation.y = -atan2(velocity.z, velocity.x)
	
	move_and_slide()
