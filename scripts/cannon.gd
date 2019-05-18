extends StaticBody2D

var ball = load("res://environment/enemies/cannonball.tscn")

func _ready():
	$Timer.connect("timeout", self, "shoot")
	$Trigger.connect("body_entered", self, "onBodyTrigger")
	$Trigger.connect("body_exited", self, "onBodyTriggerExit")

func shoot():
	var newBall = ball.instance()
	newBall.position = global_position
	get_tree().current_scene.call_deferred("add_child", newBall)
	
func onBodyTrigger(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		$Trigger.disconnect("body_entered", self, "onBodyTrigger")
		shoot()
		$Timer.start(2.0)
	
func onBodyTriggerExit(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		queue_free()