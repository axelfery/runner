extends Control

var coins = 0
var stars = [0, 0, 0]
var elapsedTime = 0.0
var timeOut = 0.0
var texture = load(assets.STAR_FILL)

func _ready():
	global.connect("coinCollected", self, "onCoinsCollected")
	global.connect("starCollected", self, "onStarCollected")
	global.connect("levelStarted", self, "onLevelStarted")
	global.connect("levelCompleted", self, "onLevelCompleted")
	set_process(false)
	
func onCoinsCollected():
	coins += 1
	$Coin/Label.set_text("x" + str(coins))
	
func onStarCollected(number):
	if(number == 1):
		stars[0] = 1
		$Stars/Star1.texture = texture
	elif(number == 2):
		stars[1] = 1
		$Stars/Star2.texture = texture
	elif(number == 3):
		stars[2] = 1
		$Stars/Star3.texture = texture

func onLevelStarted():
	set_process(true)
	
func onLevelCompleted():
	if(coins > global.worlds[global.selectedWorld].levels[global.selectedLevel].coins):
		global.worlds[global.selectedWorld].levels[global.selectedLevel].coins = coins
	if(elapsedTime < global.worlds[global.selectedWorld].levels[global.selectedLevel].timeInSec or global.worlds[global.selectedWorld].levels[global.selectedLevel].timeInSec == 0):
		global.worlds[global.selectedWorld].levels[global.selectedLevel].timeInSec = elapsedTime	
	for i in stars.size():
		if(stars[i] == 1):
			global.worlds[global.selectedWorld].levels[global.selectedLevel].stars[i] = 1
	set_process(false)

func _process(delta):
	elapsedTime += delta
	timeOut +=  delta
	if(timeOut >= 1.0):
		timeOut = 0.0
		var minutes:float = elapsedTime / 60
		var seconds:float = (minutes - int(minutes)) * 60
		$Time.text = str(int(minutes)).pad_zeros(2) + " : " + str(int(seconds)).pad_zeros(2)
