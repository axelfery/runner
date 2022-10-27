tool
extends Node2D

export(int, 1, 20) var amount = 1 setget amountChanged
export(int, 50, 600) var distance = 50 setget distanceChanged
export(float, 200, 800, 50) var velocity = 400
export(float, 0.05, 1.0, 0.01) var delay = 0.1

var spikes = []
var index:int = 0
var spike = load(assets.SPIKE)

func _ready():
	$Trigger.connect("body_entered", self, "onBodyEntered")

func onBodyEntered(body: KinematicBody2D)->void:
	if(body.is_in_group(assets.GROUP_CHARACTERS)):
		$Trigger.disconnect("body_entered", self, "onBodyEntered")
		onTimeout()
		$Timer.start(delay)

func _enter_tree():
	if(not spikes.empty()): deleteSpikes()
	for i in amount:
		var newSpike = spike.instance()
		newSpike.position.x = i * distance
		spikes.append(newSpike)
		$Holder.add_child(newSpike)

func amountChanged(a):
	amount = a
	if(Engine.editor_hint):
		while(amount != spikes.size()):
			if(amount < spikes.size()):
				spikes[spikes.size() - 1].queue_free()
				spikes.remove(spikes.size() - 1)
			elif(amount > spikes.size()):
				var newSpike = spike.instance()
				newSpike.position.x = distance * spikes.size()
				spikes.append(newSpike)
				$Holder.add_child(newSpike)

func distanceChanged(d):
	distance = d
	if(Engine.editor_hint):
		for i in spikes.size():
			spikes[i].position.x = i * distance
			

func deleteSpikes():
	spikes.clear()
	for i in range($Holder.get_child_count() - 1):
		$Holder.get_child(i + 1).queue_free()

func onTimeout():
	if(index < spikes.size()):
		spikes[index].emerge(velocity)
		index += 1
	else: $Timer.stop()
