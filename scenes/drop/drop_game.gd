extends Node2D
class_name DropGame

@export var all_drop_items: Array[DropItemData]
@export var items_root: Node


var items_to_spawn: PackedVector3Array	
	
	
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


func _on_toparea_body_entered(body: Node2D) -> void:
	if not body.is_in_group("dropitem"):
		return
	
	body.toparea = true
	body.hasHitTop = true

func _on_toparea_body_exited(body: Node2D) -> void:
	if not body.is_in_group("dropitem"):
		return

	body.toparea = false


func _on_topoverflow_body_entered(body: Node2D) -> void:
	if not body.is_in_group("dropitem"):
		return
	
	body.topoverflow = true
	
	if not body.toparea and body.hasHitTop:
		Globals.game_over.emit()
	
func _on_topoverflow_body_exited(body: Node2D) -> void:
	if not body.is_in_group("dropitem"):
		return
		
	body.topoverflow = false
	
	

const GUI_PAUSE := preload("res://gui/pause.tscn")
const GUI_GAME_OVER := preload("res://gui/game_over.tscn")

var checkpoint := 0


func _ready() -> void:
	Globals.game = self
	Globals.game_over.connect(_on_game_over)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"ui_cancel"):
		if not get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			var gui_pause = GUI_PAUSE.instantiate()
			get_tree().root.add_child(gui_pause)

func _on_game_over() -> void:
	if not get_tree().paused:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var gui_game_over = GUI_GAME_OVER.instantiate()
		get_tree().root.add_child.call_deferred(gui_game_over)
