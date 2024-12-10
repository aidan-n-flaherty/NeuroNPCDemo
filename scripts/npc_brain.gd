extends AgentBrain

var currentAction: Action

func init(id: int, artificial=true, agentName=["", ""]):
	super.init(id, artificial, agentName)
	
	AgentManager.sendCommand.connect(processCommand)

func processCommand(agentID: int, action: Action):
	print(agentID, ", ", self.id, ", ", action)
	if agentID != self.id:
		return
	
	if action.actionType == 'say':
		get_parent().displaySpeechBubble(action.parameters[0])
	else:
		currentAction = action

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
