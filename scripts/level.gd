extends Node

class_name Level

var path = ""
var stars = [0, 0, 0]
var coins = 0
var timeInSec = 0
var unlocked = false

func _init(path):
	self.path = path

func getLevel():
	var level = load(path)
	return level.instance()
