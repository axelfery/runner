extends Node

var worlds = []
var selectedWorld = 0
var selectedLevel = 0

func _ready():
	createWorlds()

func createWorlds():
	var world1: GameWorld = GameWorld.new(self, "res://worlds/world1/")
	var world2: GameWorld = GameWorld.new(self, "res://worlds/world2/")
	var world3: GameWorld = GameWorld.new(self, "res://worlds/world3/")
	var world4: GameWorld = GameWorld.new(self, "res://worlds/world4/")
	world1.unlocked = true
	world1.levels[0].unlocked = true
	world2.unlocked = true
	world2.levels[0].unlocked = true
	worlds.append(world1)
	worlds.append(world2)
	worlds.append(world3)
	worlds.append(world4)
    
class GameWorld:
	
	var node
	var path = ""
	var gemsCollected = 0
	var levels = []
	var unlocked = false
	
	func _init(node, path):
		self.node = node
		self.path = path
		addLevels()
	
	func addLevels():
		var directory: Directory = Directory.new()
		if directory.open(path) == OK:
			
			directory.list_dir_begin()
			var fileName = directory.get_next()
			while(fileName != ""):
				if(not directory.current_is_dir()):
					var level: Level = Level.new(path + fileName)
					levels.append(level)
				fileName = directory.get_next()

class Level:
	
	var path = ""
	var gemsCollected = 0
	var unlocked = false
	
	func _init(path):
		self.path = path
	
	func loadLevel():
		var level = load(path)
		return level.instance()