extends KinematicBody2D

const GRAVITY = 90
const SPEED = 400
const ROTATIONSPEED = 4
var velocity = Vector2()
var floorNormal = Vector2(0, -1)
var direction = -1

func _ready():
	$Area.connect("body_entered", self, "onBodyEntered")
	$Visibility.connect("screen_entered", self, "onScreenEntered")
	$Visibility.connect("screen_exited", self, "onScreenExited")
	set_physics_process(false)

func onBodyEntered(body: KinematicBody2D)-> void:
	if(body.is_in_group(assets.groupPlayer)):
		body.setState(body.States.HIT)
		
func onScreenEntered():
	set_physics_process(true)
	
func onScreenExited():
	queue_free()
	
func _physics_process(delta):
	velocity.x = direction * SPEED
	velocity.y += GRAVITY
	$Sprite.rotate(direction * ROTATIONSPEED * delta)
	move_and_slide(velocity, floorNormal)
	if(is_on_floor()):
		velocity.y = 0