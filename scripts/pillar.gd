extends StaticBody2D

export(bool) var falls = true
var speedRotation = 1

func _ready():
	set_physics_process(false)
	if(not falls): return
	$Trigger.connect("body_entered", self, "onBodyTrigger")

func onBodyTrigger(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		$Trigger.disconnect("body_entered", self, "onBodyTrigger")
		set_physics_process(true)

func _physics_process(delta):
	speedRotation += 0.06
	rotate(speedRotation * delta)
	if($Top.is_colliding() or $Middle.is_colliding()):
		set_physics_process(false)