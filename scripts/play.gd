extends Node

enum Status {MAIN, PAUSE, OVER, FINISHED}

func _ready():
	var level = global.worlds[global.selectedWorld].levels[global.selectedLevel].getLevel()
	add_child(level)
	global.connect("stateHit", self, "onStateHit")
	global.connect("levelCompleted", self, "onLevelCompleted")
	showStatus(Status.MAIN)

func showStatus(status):
	if(status == Status.MAIN):
		$GUI/Main.show()
		$GUI/Pause.hide()
		$GUI/Over.hide()
		$GUI/Finished.hide()
	elif(status == Status.PAUSE):
		$GUI/Main.hide()
		$GUI/Pause.show()
		$GUI/Over.hide()
		$GUI/Finished.hide()
	elif(status == Status.OVER):
		$GUI/Main.hide()
		$GUI/Pause.hide()
		$GUI/Over.show()
		$GUI/Finished.hide()
	elif(status == Status.FINISHED):
		$GUI/Main.hide()
		$GUI/Pause.hide()
		$GUI/Over.hide()
		$GUI/Finished.show()

func _notification(what):
	if(what == MainLoop.NOTIFICATION_WM_FOCUS_IN):
		pass
	elif(what == MainLoop.NOTIFICATION_WM_FOCUS_OUT):
		if($GUI/Main.visible):
			_on_ButtonPause_pressed()
	elif(what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		if(get_tree().paused):
			_on_ButtonResume_pressed()
		elif($GUI/Main.visible):
			_on_ButtonPause_pressed()
	elif(what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		pass

func _on_ButtonPause_pressed():
	get_tree().paused = true
	showStatus(Status.PAUSE)
	
func _on_ButtonResume_pressed():
	showStatus(Status.MAIN)
	get_tree().paused = false

func _on_ButtonHome_pressed():
	get_tree().paused = false
	get_tree().change_scene(assets.MENU_MAIN)

func _on_ButtonRestart_pressed():
	get_tree().paused = false
	get_tree().change_scene(assets.MENU_PLAY)

func onStateHit():
	showStatus(Status.OVER)

func onLevelCompleted():
	global.disconnect("levelCompleted", self, "onLevelCompleted")
	if(global.selectedLevel < global.worlds[global.selectedWorld].levels.size() - 1):
		var nextLevel = global.selectedLevel + 1
		global.worlds[global.selectedWorld].levels[nextLevel].unlocked = true
		showStatus(Status.FINISHED)
	elif(global.selectedLevel == global.worlds[global.selectedWorld].levels.size() - 1):
		if(global.selectedWorld == global.worlds.size() - 1):
			global.emit_signal("gameCompleted")
			return
		var nextWorld = global.selectedWorld + 1
		var nextLevel = 0
		global.worlds[nextWorld].unlocked = true
		global.worlds[nextWorld].levels[nextLevel].unlocked = true
		showStatus(Status.FINISHED)

func _on_ButtonNext_pressed():
	if(global.selectedLevel < global.worlds[global.selectedWorld].levels.size() - 1):
		global.selectedLevel += 1
	elif(global.selectedLevel == global.worlds[global.selectedWorld].levels.size() - 1):
		global.selectedWorld += 1
		global.selectedLevel = 0
	get_tree().change_scene(assets.MENU_PLAY)
