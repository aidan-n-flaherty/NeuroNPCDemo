extends CharacterBody3D

@export var speed = 5

var move_path: PackedVector3Array

var speechBubble = null

var timeout = -1

var target = null

var attacking = null

func _ready() -> void:
	$Brain.init(1)
	AgentManager.sendCommand.connect(acceptCommand)

func acceptCommand(agentID: int, action: Action):
	if action.actionType == 'say':
		displaySpeechBubble(action.parameters[0])

func setTarget(target) -> void:
	self.target = target

func _process(delta: float) -> void:
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
	var movement = Vector3()
	
	if target:
		var direction = target.position - position
		direction.y = 0
		direction.x *= -1
		
		movement = direction.normalized() * speed
	
	velocity.x = 0.9 * velocity.x + 0.1 * -movement.x
	velocity.z = 0.9 * velocity.z + 0.1 * movement.z
	
	if velocity.z != 0 or velocity.x != 0:
		rotation.y = -atan2(velocity.z, velocity.x)
	
	move_and_slide()
