extends MarginContainer


var itemName: String

var id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(id: int, itemName: String):
	self.id = id
	self.itemName = itemName
	
	$MarginContainer/Label.text = itemName

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
