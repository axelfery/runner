extends Node

enum Status{MAIN, SETTINGS, QUIT}

func _ready():
	showStatus(Status.MAIN)

func showStatus(status):
	if(status == Status.MAIN):
		$Main.show()
		$Settings.hide()
		$Quit.hide()
	elif(status == Status.SETTINGS):
		$Main.hide()
		$Settings.show()
		$Quit.hide()
	elif(status == Status.QUIT):
		$Main.hide()
		$Settings.hide()
		$Quit.show()

func _notification(what):
	if(what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		_on_ButtonBack_pressed()
	elif(what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		if(not $Quit.visible):
			showStatus(Status.QUIT)

func _on_ButtonPlay_pressed():
	get_tree().change_scene(assets.MENU_WORLD)

func _on_ButtonBack_pressed():
	if($Main.visible):
		showStatus(Status.QUIT)
	elif($Quit.visible):
		showStatus(Status.MAIN)

func _on_ButtonYes_pressed():
	get_tree().quit() 

func _on_ButtonNo_pressed():
	showStatus(Status.MAIN)
