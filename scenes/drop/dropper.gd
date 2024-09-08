extends RigidBody2D

@export var look_sensitivity:float = 1.0

@export var max_spawn_index:int = 3

var current_item:RigidBody2D

#@export var item_drop_joint : PinJoint2D
@export var items_root : Node2D

func _input(event: InputEvent) -> void:
	# should check game state
	if event is InputEventMouseMotion:
		position += Vector2.RIGHT * event.relative.x
		apply_central_impulse(Vector2.RIGHT * event.relative.x * look_sensitivity)

func _process(delta: float) -> void:
	if current_item == null and $spawnTimer.is_stopped() and Globals.game:
		var id = randi_range(0, max_spawn_index)
		var item = Globals.game.all_drop_items[id]
		current_item = item.scene.instantiate()
		current_item.type = id
		current_item.mass = item.mass
		current_item.isAlive = false
		items_root.add_child(current_item)
		current_item.global_position = global_position # + Vector2(0, 20)
		$item_drop_joint.node_b = current_item.get_path()
		
		
		
	if Input.is_action_just_released("drop_item"):
		if current_item:
			current_item.isAlive = true
			if not Input.is_action_pressed("debug_mod"):
				$spawnTimer.start()
				
			$item_drop_joint.node_b = NodePath()
			current_item = null
		
