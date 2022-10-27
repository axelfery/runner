extends Line2D

export(float, 1.0, 100.0, 0.5) var lineWidth = 10
export(int, 5, 50, 1) var length = 10
export(float, -50.0, 50.0, 0.5) var positionOffset = 0.0
export(Color) var color = Color.white
export(Gradient) var lineGradient = null
export(Curve) var lineCurve = null

var trailIsOn = true setget showTrail

func _ready():
	clear_points()
	width = lineWidth
	default_color = color
	gradient = lineGradient
	width_curve = lineCurve

func _process(delta):
	if(not trailIsOn): return
	global_position = Vector2(0.0, positionOffset)
	rotation = 0
	add_point(get_parent().global_position)
	if(get_point_count() > length):
		remove_point(0)

func showTrail(on):
	clear_points()
	trailIsOn = on
