extends CharacterBody3D

signal inventoryChanged

@export var speed = 1.25

var speechBubble = null

var timeout = -1

var health = 10

var direction = 0

var inventory = []

var id: int

var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Brain.init(1, false, ['John', 'Doe'])
	self.id = $Brain.id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("open_chat") and not speechBubble:
		var node = preload("res://scenes/3D/SpeechBubble.tscn").instantiate()
		node.init(true)
		node.sendMessage.connect(displaySpeechBubble)
		add_child(node)
		
		speechBubble = node
	
	if timeout > 0:
		timeout -= delta
		
		if not timeout > 0:
			remove_child(speechBubble)
			speechBubble = null
	
	if Input.is_action_just_released("escape"):
		remove_child(speechBubble)
		speechBubble = null

func displaySpeechBubble(text: String):
	var action = Action.new()
	action.init('say', [text])
	$Brain.emitAction(action)
	
	if speechBubble:
		remove_child(speechBubble)
		speechBubble = null
	
	var node = preload("res://scenes/3D/SpeechBubble.tscn").instantiate()
	node.init(false, text, true)
	add_child(node)
	
	speechBubble = node
	
	timeout = 2 + int(len(text) / 10)

func add_inventory_item(item: Node):
	self.inventory.append(item)
	
	if item.get_parent():
		item.get_parent().remove_child(item)
	
	var inventoryIDs = []
	
	for obj in self.inventory:
		inventoryIDs.append(obj.id)
	$Brain.update({ "inventory": inventoryIDs })
	emit_signal("inventoryChanged")
	
	print(inventoryIDs)

func getInventory():
	var inv = []
	
	for obj in self.inventory:
		inv.append([obj.id, obj.itemName])
	
	return inv
	
func decreaseHealth(amount: int):
	health -= amount
	$Character3D/CharacterAnimator.setHurt()

func _physics_process(delta: float) -> void:
	var suppress = speechBubble and speechBubble.isEditing()
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement = speed * input_dir.normalized() if not suppress else Vector2()
	movement.y *= -1
	
	if movement.x != 0 or movement.y != 0:
		$Character3D/CharacterAnimator.setAnimation('walk')
	else:
		$Character3D/CharacterAnimator.setAnimation('idle')
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("jump") and is_on_floor() and not suppress:
		print(suppress)
		velocity.y = speed
		movement *= 10
	
	if Input.is_action_just_released("run"):
		movement.x *= 30
		movement.y *= 30
	
	velocity.x = 0.9 * velocity.x + 0.1 * -movement.x
	velocity.z = 0.9 * velocity.z + 0.1 * movement.y
	
	if movement.distance_to(Vector2()) > 0.01:
		var angle = atan2(movement.y, movement.x) + PI
		var CS = 0.9 * cos(rotation.y) + 0.1 * cos(angle)
		var SN = 0.9 * sin(rotation.y) + 0.1 * sin(angle)
		var C = atan2(SN,CS)
		rotation.y = C
	
	if move_and_slide():
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			if Input.is_action_pressed("jump") and col.get_collider() is CharacterBody3D:
				if not attacking:
					var action = Action.new()
					action.init('attack', [col.get_collider().id])
					$Brain.emitAction(action)
					col.get_collider().decreaseHealth(1)
					attacking = true
			else:
				attacking = false
			if col.get_collider() is CharacterBody3D:
				col.get_collider().velocity = col.get_normal() * -0.5 * movement.distance_to(Vector2())
			if col.get_collider() is RigidBody3D:
				col.get_collider().apply_force(col.get_normal() * -5 * movement.distance_to(Vector2()))
