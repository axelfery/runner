extends KinematicBody2D

var velocity = Vector2()
var floorNormal = Vector2(0, -1)
export(int) var direction = -1

const GRAVITY = 90
const SPEED = 200

onready var bottom = $Bottom

func _ready():
	$Area.connect("body_entered", self, "onBodyEntered")
	$Trigger.connect("body_entered", self, "onBodyTrigger")
	$Trigger.connect("body_exited", self, "onBodyTriggerExit")
	set_physics_process(false)
	if(direction == 1):
		scale.x *= -1
	
func _physics_process(delta):
	velocity.x = direction * SPEED
	velocity.y += GRAVITY
	move_and_slide(velocity, floorNormal)
	
	if(not bottom.is_colliding() or is_on_wall()):
		direction *= -1
		scale.x *= -1
	
	if(is_on_floor()):
		velocity.y = 0

func onBodyEntered(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		body.setState(body.States.HIT)
		
func onBodyTrigger(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		$Trigger.disconnect("body_entered", self, "onBodyTrigger")
		set_physics_process(true)
		$Animation.play("strech")
	
func onBodyTriggerExit(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		queue_free()