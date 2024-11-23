extends Area2D

var canInteract = false
var interaction = false
@onready var canInteractLabel = $"CanInteractLabel"


func _process(delta: float) -> void:
	if canInteract:
		canInteractLabel.text = "Press T to talk to the Bartender"
	else:
		canInteractLabel.text = ""



func _on_body_entered(body: CharacterBody2D) -> void:
	canInteract = true



func _on_body_exited(body: CharacterBody2D) -> void:
	canInteract = false 
