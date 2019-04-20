extends StaticBody2D

export(bool) var canFall = true
var speedRotation = 1

func _ready():
	$VisibilityNotifier.connect("screen_exited", self, "onScreenExited")
	set_process(false)
	if(not canFall): return
	$Area.connect("body_entered", self, "onBodyEntered")

func onBodyEntered(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		fall()
		
func fall():
	$Area.disconnect("body_entered", self, "onBodyEntered")
	set_process(true)

func _process(delta):
	speedRotation += 0.06
	rotate(speedRotation * delta)
	if($Top.is_colliding() or $Middle.is_colliding()):
		set_process(false)

func onScreenExited():
	queue_free()