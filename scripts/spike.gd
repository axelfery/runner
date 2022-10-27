extends Area2D

var distance
var initialPositionY
var velocity

func _ready():
	connect("body_entered", self, "onBodyEntered")
	set_physics_process(false)
	
func onBodyEntered(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		body.setState(body.States.HIT)

func emerge(vel):
	velocity = vel
	initialPositionY = position.y
	distance = $Sprite.texture.get_size().y / 2
	set_physics_process(true)
	
func _physics_process(delta):
	if(position.y > initialPositionY - distance):
		move_local_y(-velocity * delta)
	else:
		set_physics_process(false)
		return
