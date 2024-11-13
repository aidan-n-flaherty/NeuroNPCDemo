extends Area2D

func _on_body_entered(body: CharacterBody2D) -> void:
	
	if "Player" in body.name:
		if get_tree().current_scene.name == "Inside":
			# Change scene from Inside to Outside
			get_tree().change_scene_to_file.bind("res://scenes/Outside.tscn").call_deferred()
			
		
		elif get_tree().current_scene.name == "Outside":
			## Change scene from Outside to Inside
			get_tree().change_scene_to_file.bind("res://scenes/Inside.tscn").call_deferred()
			
