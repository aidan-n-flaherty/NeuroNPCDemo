extends MarginContainer

signal sendMessage(text: String)

var text
var elapsed = 0
var visibleText

func init(editable: bool, text="", fullyVisible=false):
	self.text = text
	self.visibleText = len(text) if fullyVisible else 0
	
	$VBoxContainer/MarginContainer/MarginContainer/LineEdit.editable = editable
	$VBoxContainer/MarginContainer/MarginContainer/LineEdit.text = text if fullyVisible else ""
	_on_line_edit_text_changed($VBoxContainer/MarginContainer/MarginContainer/LineEdit.text)
	
	if editable:
		$VBoxContainer/MarginContainer/MarginContainer/LineEdit.grab_focus.call_deferred()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed += delta
	
	if elapsed >= 0.025 and not $VBoxContainer/MarginContainer/MarginContainer/LineEdit.editable:
		visibleText += 1
		if visibleText > len(text):
			visibleText = len(text)
		$VBoxContainer/MarginContainer/MarginContainer/LineEdit.text = text.substr(0, visibleText)
		_on_line_edit_text_changed($VBoxContainer/MarginContainer/MarginContainer/LineEdit.text)
		
		elapsed = 0
	
	var pos_3d = get_parent().global_position + Vector3(0, 2, 0)
	var cam = get_viewport().get_camera_3d()
	var pos_2d = cam.unproject_position(pos_3d)
	
	global_position = pos_2d - Vector2(self.size.x/2, 0)
	visible = not cam.is_position_behind(pos_3d)

func _on_line_edit_text_submitted(new_text: String) -> void:
	emit_signal("sendMessage", new_text)
	$VBoxContainer/MarginContainer/MarginContainer/LineEdit.clear()

func isEditing():
	return $VBoxContainer/MarginContainer/MarginContainer/LineEdit.has_focus()

func _on_line_edit_text_changed(text: String) -> void:
	var f = get_theme_font("font")
	var textsize = f.get_string_size($VBoxContainer/MarginContainer/MarginContainer/LineEdit.text, 0, -1, 25)
	size.x = textsize.x + 60 + 32
