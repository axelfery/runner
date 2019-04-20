extends Node

var gem = 0 setget setGem
signal gemChanged

signal stateHit

func setGem(amount: int):
	gem = amount
	emit_signal("gemChanged", gem)
	