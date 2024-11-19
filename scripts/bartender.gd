extends Area2D

var canInteract = false
var interaction = false
@onready var canInteractLabel = $"CanInteractLabel"

func _on_body_entered(body: CharacterBody2D) -> void:
	canInteract = true
	print_debug("Player Collided with Bartender")

func _on_body_exited(body: CharacterBody2D) -> void:
	canInteract = false 
	print_debug("Player no longer with Bartender")
