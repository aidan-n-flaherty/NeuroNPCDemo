extends Area2D

@export var item: InvItem
var player = null

func _on_body_entered(body: CharacterBody2D) -> void:
	player = body
	
	# if Input.is_action_pressed("collect_item"):
	print_debug("Item Collected!")
	player.collect(item)
	queue_free()
