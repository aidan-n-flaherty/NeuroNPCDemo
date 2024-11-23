extends Node
class_name AgentBrain

var http_manager: HTTPManager

var id: int

func init(id: int, artificial=true):
	self.http_manager = HTTPManager.new()
	add_child(self.http_manager)
	
	self.id = id
	"""await http_manager.postReq('/registerAgent', {
		"worldID": 0,
		"agent": {
			"artificial": artificial,
			"id": id,
			"name": name,
			"locationID": 0,
			"coordinates": [0, 0, 0],
			"inventory": []
		}
	})"""
	
	AgentManager.registerAgent(id, get_parent())

func emitAction(action: Action):
	AgentManager.emitAction(id, action)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
