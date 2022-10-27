extends Control

var elapsedTime = 0
var time = 0

func _ready():
	$FPS.text = "FPS: " + str(Engine.get_frames_per_second()
		) + "   MEMORY: " + str(OS.get_static_memory_usage()/1048576) + " MB"
	
func _process(delta):
	elapsedTime += delta
	time +=  delta
	if(time >= 1):
		time = 0
		$ElapsedTime.text = "Time: " + str(int(elapsedTime))
		$FPS.text = "FPS: " + str(Engine.get_frames_per_second()
		) + "   MEMORY: " + str(OS.get_static_memory_usage()/1048576) + " MB"
