extends Node
class_name Action

var actionType
var parameters

func init(actionType: String, parameters: Array):
	self.actionType = actionType
	self.parameters = parameters

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
