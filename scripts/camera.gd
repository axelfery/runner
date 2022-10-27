extends Camera2D

var duration = 0.3
var amplitude = 1.0
var intensity = 10.0
var initialOffset = Vector2()

func _ready():
	limit_bottom = get_viewport_rect().size.y
	global.connect("cameraShake", self, "startShaking")
	set_process(false)
	initialOffset = offset

func startShaking(newIntensity, newDuration):
	randomize()
	intensity = newIntensity
	duration = newDuration
	$Timer.start(duration)
	set_process(true)
	
func _process(delta):
	shake(delta)
		
func shake(delta):
	rotating = true
	offset = initialOffset
	rotation = 0.0
	offset.x += intensity * rand_range(-amplitude, amplitude)
	offset.y += intensity * rand_range(-amplitude, amplitude)
	rotation += intensity * rand_range(-amplitude, amplitude)

func reset():
	rotating = false
	offset = initialOffset
	rotation = 0
	set_process(false)
	$Timer.stop()
