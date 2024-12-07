extends CharacterBody3D

@export var speed = 1.25

var move_path: PackedVector3Array

var speechBubble = null

var timeout = -1

var cooldown = 30

var inventory = []

var health = 10

var id: int

func _ready() -> void:
	$Brain.init(2, true, ['Jane', 'Doe'])
	self.id = $Brain.id

func _process(delta: float) -> void:
	if timeout > 0:
		timeout -= delta
		
		if not timeout > 0:
			remove_child(speechBubble)
			speechBubble = null

func decreaseHealth(amount: int):
	health -= amount
	
	$Character3D/CharacterAnimator.setHurt()

func displaySpeechBubble(text: String):
	var action = Action.new()
	action.init('say', [text])
	$Brain.emitAction(action)
	
	if speechBubble:
		remove_child(speechBubble)
		speechBubble = null
	
	var node = preload("res://scenes/3D/SpeechBubble.tscn").instantiate()
	node.init(false, text)
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
	
	
func remove_inventory_item(id: int):
	var index = -1
	var item = null
	for i in range(len(self.inventory)):
		if self.inventory[i].id == id:
			index = i
			item = self.inventory[i]
	
	if index >= 0:
		self.inventory.remove_at(index)
	var inventoryIDs = []
	
	for obj in self.inventory:
		inventoryIDs.append(obj.id)
	
	$Brain.update({ "inventory": inventoryIDs })
	
	return item

func _physics_process(delta: float) -> void:
	var movement = Vector2()
	
	var target = null
	
	if $Brain.currentAction:
		if $Brain.currentAction.isType('attack'):
			target = AgentManager.getAgent($Brain.currentAction.getParameter(0))
		elif $Brain.currentAction.isType('pick_up_item'):
			target = AgentManager.getItem($Brain.currentAction.getParameter(0))
			
			if not target.get_parent():
				target = null
		elif $Brain.currentAction.isType('give_item'):
			target = AgentManager.getAgent($Brain.currentAction.getParameter(0))
		elif $Brain.currentAction.isType('follow'):
			target = AgentManager.getAgent($Brain.currentAction.getParameter(0))
	
	if target:
		var direction = Vector2(target.position.x - position.x, target.position.z - position.z)
		direction.x *= -1
		
		movement = direction.normalized() * speed
	
	
	if movement.x != 0 or movement.y != 0:
		$Character3D/CharacterAnimator.setAnimation('walk')
	else:
		$Character3D/CharacterAnimator.setAnimation('idle')
	
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
			if col.get_collider() == target:
				if $Brain.currentAction.isType('attack'):
					if cooldown == 0:
						target.decreaseHealth(1)
						cooldown = 30
						
						$Brain.currentAction = null
					else:
						cooldown -= 1
				elif $Brain.currentAction.isType('pick_up_item'):
					if target.get_parent():
						target.get_parent().remove_child(target)
						
						add_inventory_item(target)
						
						$Brain.currentAction = null
				elif $Brain.currentAction.isType('give_item'):
					var agent = AgentManager.getAgent($Brain.currentAction.getParameter(0))
					
					if agent:
						var item = remove_inventory_item($Brain.currentAction.getParameter(1))
						
						if item:
							agent.add_inventory_item(item)
						
					
					$Brain.currentAction = null
			if col.get_collider() is CharacterBody3D:
				col.get_collider().velocity = col.get_normal() * -0.5 * movement.distance_to(Vector2())


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	pass # Replace with function body.
