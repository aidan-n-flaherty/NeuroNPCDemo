extends Node
class_name Item

var http_manager: HTTPManager

var id: int

func init(id: int, itemName=""):
	self.http_manager = HTTPManager.new()
	add_child(self.http_manager)
	
	self.id = id
	await http_manager.postReq('/registerItem', {
		"worldID": 0,
		"item": {
			"id": id,
			"name": itemName,
			"locationID": 0,
			"coordinates": [0, 0, 0]
		}
	})
	
	AgentManager.registerItem(id, get_parent())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
