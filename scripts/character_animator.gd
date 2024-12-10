extends AnimationTree

var transition = 0

var hurt = 0

var animation = "Walk"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setAnimation(animationName: String) -> void:
	animation = animationName

func setHurt():
	hurt = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var val = 0 if animation == 'walk' else 1 if animation == 'idle' else 0
	
	transition = 0.95 * transition + 0.05 * val
	
	self["parameters/WalkIdle/blend_amount"] = transition
	$"../Armature/Skeleton3D/Cube".get_surface_override_material(0).albedo_color = Color(hurt/30.0, 0.0, 0.0)
	
	if hurt > 0:
		hurt -= 1
