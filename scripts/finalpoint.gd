extends Area2D

func _ready():
	connect("body_entered", self, "onBodyEntered")

func onBodyEntered(body: KinematicBody2D) ->void:
	if(body.is_in_group(assets.groupPlayer)):
		body.setState(body.States.HIT)