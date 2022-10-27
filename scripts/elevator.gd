extends StaticBody2D

export(bool) var fixed = false
export(float, 50.0, 600.0, 10.0) var distance = 50.0
export(int, -1, 1, 2) var direction = -1
var speed = 300.0
var initialPositionY = 0

func _ready():
	set_physics_process(false)
	if(fixed): return
	$Trigger.connect("body_entered", self, "onBodyTrigger")
	initialPositionY = position.y

func onBodyTrigger(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		$Trigger.disconnect("body_entered", self, "onBodyTrigger")
		set_physics_process(true)

func _physics_process(delta):
	if(distance <= 0):
		set_physics_process(false)
		return
	move_local_y(direction * speed * delta)
	distance -= speed * delta
