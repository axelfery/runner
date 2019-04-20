extends Control

var elapsedTime = 0
var time = 0

func _ready():
	pass
	
func _process(delta):
	elapsedTime += delta
	$ElapsedTime.text = "Time: " + str(int(elapsedTime))
	time +=  delta
	if(time >= 2):
		time = 0
		$FPS.text = "FPS: " + str(Engine.get_frames_per_second())