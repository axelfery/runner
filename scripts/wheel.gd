extends KinematicBody2D

const GRAVITY = 90
const SPEED = 400
const ROTATION_SPEED = 5
var velocity = Vector2()
var floorNormal = Vector2(0, -1)
export(int, -1, 1, 2) var direction = -1

func _ready():
	$Area.connect("body_entered", self, "onBodyEntered")
	$Trigger.connect("body_entered", self, "onBodyTrigger")
	$Trigger.connect("body_exited", self, "onBodyTriggerExit")
	set_physics_process(false)

func onBodyEntered(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		body.setState(body.States.HIT)
		
func onBodyTrigger(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		$Trigger.disconnect("body_entered", self, "onBodyTrigger")
		set_physics_process(true)
	
func onBodyTriggerExit(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		queue_free()
	
func _physics_process(delta):
	velocity.x = direction * SPEED
	velocity.y += GRAVITY
	$Sprite.rotate(direction * ROTATION_SPEED * delta)
	move_and_slide(velocity, floorNormal)
	if(is_on_floor()):
		velocity.y = 0
