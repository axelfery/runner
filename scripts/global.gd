extends Node

signal cameraShake
signal stateHit
signal coinCollected
signal starCollected
signal levelStarted
signal levelCompleted
signal gameCompleted

var doubleJumpUnlocked = true
var glideUnlocked = true

var characters = []
var worlds = []
var selectedCharacter = 0
var selectedWorld = 0
var selectedLevel = 0

func _ready():
	createWorlds()
	addCharacters()

func createWorlds():
	var world1 = GameWorld.new(assets.WORLD1)
	var world2 = GameWorld.new(assets.WORLD2)
	var world3 = GameWorld.new(assets.WORLD3)
	var world4 = GameWorld.new(assets.WORLD4)
	world1.unlocked = true
	world1.levels[0].unlocked = true
	world1.levels[1].unlocked = true
	world1.levels[2].unlocked = true
	
	worlds.append(world1)
	worlds.append(world2)
	worlds.append(world3)
	worlds.append(world4)

func addCharacters():
	characters.append(assets.CHARACTER1)
	characters.append(assets.CHARACTER2)
