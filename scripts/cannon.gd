extends StaticBody2D

var ball = load("res://environment/enemies/cannonball.tscn")

func _ready():
	$Timer.connect("timeout", self, "shoot")
	$Visibility.connect("screen_entered", self, "onScreenEntered")
	$Visibility.connect("screen_exited", self, "onScreenExited")

func shoot():
	var newBall = ball.instance()
	newBall.position = global_position
	get_tree().current_scene.add_child(newBall)
	$Timer.start(2)
	
func onScreenEntered():
	shoot()
	
func onScreenExited():
	queue_free()