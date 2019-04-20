extends Node2D

export(int) var numberOfSpikes = 2
export(float) var velocity = 400

var distance = 80
var initialPositionY = 40
var finalPostionY = -50
var spikes = []
var index = 0

var spikeScene = load("res://environment/enemies/spike.tscn")

func _ready():
	if(numberOfSpikes <= 0): queue_free()
	$Limit.queue_free()
	for amount in range(numberOfSpikes):
		var spike = spikeScene.instance()
		spike.position.x = distance * amount
		spike.position.y = initialPositionY
		add_child(spike)
		spikes.append(spike)
	$Area.connect("body_entered", self, "onBodyEntered")
	set_process(false)

func onBodyEntered(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.groupPlayer)):
		$Area.disconnect("body_entered", self, "onBodyEntered")
		set_process(true)
	
func _process(delta):
	spikes[index].position.y -= velocity * delta
	if(spikes[index].position.y <= finalPostionY):
			index += 1
	if(index == spikes.size()):
		set_process(false)