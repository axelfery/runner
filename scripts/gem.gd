extends Area2D

const AMOUNT = 1

func _ready():
	connect("body_entered", self, "onBodyEntered")
	
func onBodyEntered(body: KinematicBody2D) ->void:
	if(body.is_in_group(assets.groupPlayer)):
		queue_free()