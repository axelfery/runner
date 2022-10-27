extends Area2D

export(int, -1, 1, 2) var direction = 1

func _ready():
	connect("body_entered", self, "onBodyEntered")
	
func onBodyEntered(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		$Animation.play("bounce")
		body.direction = direction
		body.flipBody(direction)
		body.setState(body.States.BOUNCE)
