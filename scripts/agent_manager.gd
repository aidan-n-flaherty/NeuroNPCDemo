extends Node

signal actionEmitted(action: Action)

signal sendCommand(agentID: int, action: Action)

var http_manager: HTTPManager

var websocket_manager: WebsocketManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.websocket_manager = WebsocketManager.new()
	self.http_manager = HTTPManager.new()
	add_child(self.websocket_manager)
	add_child(self.http_manager)
	
	self.websocket_manager.command.connect(acceptCommand)

func emitAction(agentID: int, action: Action):
	http_manager.postReq('/emitAction', {
		"worldID": 0,
		"agentID": agentID,
		"action": {
			"actionType": action.actionType,
			"parameters": action.parameters
		}
	})

func acceptCommand(command):
	var agentID = command['agentID']
	var action = Action.new()
	action.init(command['action']['actionType'], command['action']['parameters'])
	emit_signal("sendCommand", agentID, action)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
