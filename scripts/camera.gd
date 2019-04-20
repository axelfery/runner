extends Camera2D

func _ready():
	limit_bottom = get_viewport_rect().size.y
	limit_top = -get_viewport_rect().size.y