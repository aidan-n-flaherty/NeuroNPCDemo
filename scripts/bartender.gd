extends Area2D


func _on_body_entered(body: CharacterBody2D) -> void:
	print_debug("Player Collided with Bartender")


func _on_body_exited(body: CharacterBody2D) -> void:
	print_debug("Player no longer with Bartender")
