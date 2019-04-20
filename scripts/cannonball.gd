extends Area2D

var velocity = 0
var SPEED = 40

func _ready():
	$Timer.start(2)
	$Timer.connect("timeout", self, "onTimeout")
	connect("body_entered", self, "onBodyEntered")
	add_to_group(assets.groupEnemies)
	
func _physics_process(delta):
	velocity -= SPEED * delta
	move_local_x(velocity)
	
func onTimeout():
	queue_free()

func onBodyEntered(body: KinematicBody2D) ->void:
	if(body.is_in_group(assets.groupPlayer)):
		body.setState(body.States.HIT)