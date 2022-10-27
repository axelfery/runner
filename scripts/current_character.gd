extends Node2D

func _ready():
	$Rect.queue_free()
	var character = load(global.characters[global.selectedCharacter]).instance()
	character.position = global_position
	character.add_child(load(assets.CAMERA).instance())
	get_parent().call_deferred("add_child", character)
