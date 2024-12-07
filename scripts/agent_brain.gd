extends Node
class_name AgentBrain

var http_manager: HTTPManager

var id: int

var initialized

func init(id: int, artificial=true, agentName=["", ""]):
	self.http_manager = HTTPManager.new()
	add_child(self.http_manager)
	
	self.id = id
	await http_manager.postReq('/registerAgent', {
		"worldID": 0,
		"agent": {
			"artificial": artificial,
			"id": id,
			"name": agentName,
			"locationID": 0,
			"coordinates": [0, 0, 0],
			"inventory": []
		}
	})
	
	AgentManager.registerAgent(id, get_parent())

func update(dict: Dictionary):
	await http_manager.postReq('/setAgent', {
		"worldID": 0,
		"agent": {
			"id": id
		}.merged(dict)
	})

func emitAction(action: Action):
	AgentManager.emitAction(id, action)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
