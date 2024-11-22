extends AgentBrain

var target: Vector3

func init(id: int, artificial=true):
	super.init(id, artificial)

func processCommand(agentID: int, action: Action):
	if agentID != self.id:
		return
	
	if action.actionType == 'say':
		get_parent().displaySpeechBubble(action.parameters[0])
	if action.actionType == 'attack':
		attacking = AgentManager.getAgent(action.parameters[0])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
