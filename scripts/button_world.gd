extends TextureButton

export(int, 0, 3) var index = 0
export var label = ""
var unlocked = false

func _ready():
	$Name.text = label
	if(index >= global.worlds.size()): return
	unlocked = global.worlds[index].unlocked
	if(unlocked):
		$Locked.queue_free()

func _on_Button_pressed():
	if(unlocked):
		global.selectedWorld = index
		get_tree().change_scene(assets.MENU_LEVEL)

func _on_Button_down():
	rect_scale = Vector2(0.9, 0.9)
	
func _on_Button_up():
	rect_scale = Vector2(1.0, 1.0)
