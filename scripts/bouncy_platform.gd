extends Area2D

func _ready():
	add_to_group(assets.groupBouncePlatforms)
	connect("body_entered", self, "onBodyEntered")
	
func onBodyEntered(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		$Animation.play("bounce")
		body.setState(body.States.BOUNCE)