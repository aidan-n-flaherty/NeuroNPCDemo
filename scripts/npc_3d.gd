extends CharacterBody3D

var speechBubble = null

var timeout = -1

func _ready() -> void:
	$Brain.init(1)
	AgentManager.sendCommand.connect(acceptCommand)

func acceptCommand(agentID: int, action: Action):
	if action.actionType == 'say':
		displaySpeechBubble(action.parameters[0])

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
	move_and_slide()
