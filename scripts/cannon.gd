extends StaticBody2D

var ball = load(assets.CANNON_BALL)
export(float, 0.1, 2.0, 0.1) var delay = 1.0
export(int, -1, 1, 2) var direction = 1

func _ready():
	$Timer.connect("timeout", self, "shoot")
	$Trigger.connect("body_entered", self, "onBodyTrigger")
	$Trigger.connect("body_exited", self, "onBodyTriggerExit")

func shoot():
	var newBall = ball.instance()
	newBall.position = Vector2(global_position.x + direction * 60, global_position.y)
	newBall.direction = direction
	$Animation.stop(true)
	$Animation.play("shoot")
	get_tree().current_scene.call_deferred("add_child", newBall)
	$Timer.start(delay)
	
func onBodyTrigger(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		$Trigger.disconnect("body_entered", self, "onBodyTrigger")
		shoot()
	
func onBodyTriggerExit(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		queue_free()
