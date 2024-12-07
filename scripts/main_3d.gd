extends Node3D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player3D
	player.inventoryChanged.connect(inventoryChanged)

func inventoryChanged():
	for child in $Control/MarginContainer/MarginContainer/Inventory.get_children():
		$Control/MarginContainer/MarginContainer/Inventory.remove_child(child)
		child.queue_free()
	
	for pair in player.getInventory():
		var item = preload("res://scenes/3D/InventoryLabel.tscn").instantiate()
		item.init(pair[0], pair[1])
		$Control/MarginContainer/MarginContainer/Inventory.add_child(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target = Vector3($Player3D.position.x, $Player3D.position.y + 5, $Player3D.position.z - 5)
	
	$Camera3D.position = 0.95 * $Camera3D.position + 0.05 * target
