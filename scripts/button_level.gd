extends TextureButton

export(int) var index = 0
var unlocked = false

func _ready():
	$Number.text = str(index + 1)
	if index >= 1: return  #EXITS THIS METHOD BECAUSE THERE IS ONLY 1 LEVEL YET
	unlocked = world.worlds[world.selectedWorld].levels[index].unlocked
	if(unlocked):
		$Locked.queue_free()
func _on_Button_pressed():
	if index >= 1: return  #EXITS THIS METHOD BECAUSE THERE IS ONLY 1 LEVEL YET
	if(unlocked):
		world.selectedLevel = index
		get_tree().change_scene("res://stages/play.tscn")

func _on_Button_down():
	rect_scale = Vector2(0.9, 0.9)

func _on_Button_up():
	rect_scale = Vector2(1.0, 1.0)
