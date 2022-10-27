extends TextureButton

export(int, 0, 9) var index = 0
var unlocked = false

func _ready():
	$Number.text = str(index + 1)
	if(index >= global.worlds[global.selectedWorld].levels.size()): return
	unlocked = global.worlds[global.selectedWorld].levels[index].unlocked
	if(unlocked):
		$Locked.queue_free()
func _on_Button_pressed():
	if(unlocked):
		global.selectedLevel = index
		get_tree().change_scene(assets.MENU_PLAY)

func _on_Button_down():
	rect_scale = Vector2(0.9, 0.9)

func _on_Button_up():
	rect_scale = Vector2(1.0, 1.0)
