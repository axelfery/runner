extends Area2D

var velocity = 0
var direction = 1.0
const SPEED = 700
const ROTATION_SPEED = 30
const LIFE_TIME = 2

func _ready():
	$Timer.start(LIFE_TIME)
	$Timer.connect("timeout", self, "onTimeout")
	connect("body_entered", self, "onBodyEntered")
	
func _physics_process(delta):
	velocity = direction * SPEED * delta
	$Sprite.rotate(ROTATION_SPEED * direction * delta)
	move_local_x(velocity)
	
func onTimeout():
	queue_free()

func onBodyEntered(body: KinematicBody2D) ->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		body.setState(body.States.HIT)
