extends RigidBody3D

@export var itemName: String

@export var mesh: PackedScene

var id

func _ready() -> void:
	$Item.init(AgentManager.itemCounter, itemName)
	AgentManager.itemCounter += 1
	id = $Item.id
	
	add_child(mesh.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
