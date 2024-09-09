extends RigidBody2D
class_name DropItem

var type = 0
var isAlive = true

var topoverflow = false
var toparea = false
var hasHitTop = false

func _init() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	#connect("body_entered", _on_body_entered, CONNECT_DEFERRED)

func _on_body_entered(body: Node) -> void:
	if not isAlive:
		return
		
	if body is DropItem and body.isAlive and body.type == type:
		Globals.game.merge_items(type, self, body)
