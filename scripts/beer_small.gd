extends Area2D

@export var item: InvItem
var player = null
var can_collect = false  

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":  
		player = body
		can_collect = true 

func _on_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Player":
		can_collect = false 
		player = null

func _process(delta: float) -> void:
	if can_collect and Input.is_action_just_pressed("collect_item"):  
		collect_item()

func collect_item() -> void:
	if player:  
		print_debug("Item Collected!")
		player.collect(item)
		queue_free()
