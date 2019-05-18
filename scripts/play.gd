extends Node

enum Status {MAIN, PAUSE, OVER, FINISHED}

func _ready():
	var level = world.worlds[world.selectedWorld].levels[world.selectedLevel].loadLevel()
	add_child(level)
	app.connect("stateHit", self, "onStateHit")
	showStatus(Status.MAIN)
	
func showStatus(newStatus):
	if(newStatus == Status.MAIN):
		$GUI/Main.show()
		$GUI/Pause.hide()
		$GUI/Over.hide()
		$GUI/Finished.hide()
	elif(newStatus == Status.PAUSE):
		$GUI/Main.hide()
		$GUI/Pause.show()
		$GUI/Over.hide()
		$GUI/Finished.hide()
	elif(newStatus == Status.OVER):
		$GUI/Main.hide()
		$GUI/Pause.hide()
		$GUI/Over.show()
		$GUI/Finished.hide()
	elif(newStatus == Status.FINISHED):
		$GUI/Main.hide()
		$GUI/Pause.hide()
		$GUI/Over.hide()
		$GUI/Finished.show()

func _on_ButtonPause_pressed():
	get_tree().paused = true
	showStatus(Status.PAUSE)
	
func _on_ButtonResume_pressed():
	showStatus(Status.MAIN)
	get_tree().paused = false

func _on_ButtonHome_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://stages/menu.tscn")

func _on_ButtonRestart_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://stages/play.tscn")

func onStateHit():
	showStatus(Status.OVER)