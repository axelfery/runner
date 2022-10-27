extends KinematicBody2D

export(bool) var falls = true
var speedRotation = 1.1
const CAMERA_SHAKE_DURATION = 0.3
const CAMERA_SHAKE_INTENSITY = 20.0

func _ready():
	set_physics_process(false)
	if(not falls): return
	$Trigger.connect("body_entered", self, "onBodyTrigger")

func onBodyTrigger(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		$Trigger.disconnect("body_entered", self, "onBodyTrigger")
		set_physics_process(true)

func _physics_process(delta):
	if($Top.is_colliding() or $Middle.is_colliding() or $Bottom.is_colliding()):
		set_physics_process(false)
		global.emit_signal("cameraShake", CAMERA_SHAKE_INTENSITY, CAMERA_SHAKE_DURATION)
		return
	speedRotation += 0.1
	rotate(speedRotation * delta)
