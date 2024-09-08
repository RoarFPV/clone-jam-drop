extends Node2D
class_name DropGame

@export var all_drop_items: Array[DropItemData]
@export var items_root: Node


var items_to_spawn: PackedVector3Array	
	
func _init() -> void:
	Globals.game = self
	
	
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func merge_items(id:int, itemA:RigidBody2D, itemB:RigidBody2D) -> void:
	if (not itemA.isAlive) or (not itemB.isAlive):
		return
		
	var mid = itemA.global_position + (itemB.global_position - itemA.global_position)/2
	
	itemA.isAlive = false
	itemB.isAlive= false
	
	var score = all_drop_items[id].score
	
	Globals.score_jump += score * 2
	
	itemA.queue_free()
	itemB.queue_free()
	
	
	var next = id +1
	if next < all_drop_items.size():
		if items_to_spawn.size() < 1:
			call_deferred("apply_pending_spawns")
			
		items_to_spawn.append(Vector3(mid.x, mid.y, next))
		

func apply_pending_spawns():
	for v in items_to_spawn:
		var next = int(v.z)
		var item = all_drop_items[next]
		
		var merged = item.scene.instantiate()
		merged.mass = item.mass
		merged.type = next
		items_root.add_child(merged)
		merged.global_position = Vector2(v.x, v.y)
		
	items_to_spawn.clear()
