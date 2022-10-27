extends Node

class_name GameWorld

var path = ""
var stars = 0
var coins = 0
var levels = []
var unlocked = false

func _init(path):
	self.path = path
	addLevels()

func addLevels():
	var directory = Directory.new()
	var index:int = 0
	while(true):
		index += 1
		var filePath = path + "level" + str(index) + ".tscn"
		if(directory.file_exists(filePath)):
			var level = Level.new(filePath)
			levels.append(level)
		else: return
