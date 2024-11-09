extends Node
class_name NPC

var http_manager: HTTPManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	http_manager = HTTPManager.new()

func observeAction(action: Action):
	http_manager.postReq('/emitAction', {
		"worldID": 0,
		"action": {
			"actionType": action.actionType,
			"parameters": action.parameters
		}
	})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
