extends Node

enum Status{MAIN, CREDITS}

func _ready():
	showStatus(Status.MAIN)
	pass

func showStatus(newStatus):
	if(newStatus == Status.MAIN):
		$Main.show()
		$Credits.hide()
	elif(newStatus == Status.CREDITS):
		$Main.hide()
		$Credits.show()

func _on_ButtonPlay_pressed():
	get_tree().change_scene("res://gui/menu_world.tscn")
