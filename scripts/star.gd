extends Area2D

export(int, 1, 3) var number = 1

func _ready():
	connect("body_entered", self, "onBodyEntered")

func onBodyEntered(body: KinematicBody2D) ->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		global.emit_signal("starCollected", number)
		queue_free()
