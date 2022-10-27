extends Area2D

func _ready():
	connect("body_entered", self, "onBodyEntered")
	
func onBodyEntered(body: KinematicBody2D) ->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		global.emit_signal("coinCollected")
		queue_free()
