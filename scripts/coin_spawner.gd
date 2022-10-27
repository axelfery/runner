tool
extends Node2D

export(int, 1, 40, 1) var amount = 1 setget amountChanged
export(int, 10, 400, 5) var distance = 70 setget distanceChanged
export(int, 0, 1000, 5) var amplitude = 0 setget amplitudeChanged
export(int, 10, 500, 5) var aperture = 50 setget apertureChanged

var coins = []
var coin = load(assets.COIN)

func _enter_tree():
	if(not coins.empty()): deleteCoins()
	for i in amount:
		var newCoin = coin.instance()
		newCoin.position.x = i * distance
		newCoin.position.y = -amplitude * sin(newCoin.position.x / aperture) 
		coins.append(newCoin)
		add_child(newCoin)

func amountChanged(a):
	amount = a
	if(Engine.editor_hint):
		while(amount != coins.size()):
			if(amount < coins.size()):
				coins[coins.size() - 1].queue_free()
				coins.remove(coins.size() - 1)
			elif(amount > coins.size()):
				var newCoin = coin.instance()
				newCoin.position.x = coins.size() * distance
				newCoin.position.y = -amplitude * sin(newCoin.position.x / aperture)
				coins.append(newCoin)
				add_child(newCoin)

func distanceChanged(d):
	distance = d
	if(Engine.editor_hint):
		for i in coins.size():
			coins[i].position.x = i * distance
			coins[i].position.y = -amplitude * sin(coins[i].position.x / aperture)

func amplitudeChanged(a):
	amplitude = a
	if(Engine.editor_hint):
		for i in coins.size():
			coins[i].position.x = i * distance
			coins[i].position.y = -amplitude * sin(coins[i].position.x / aperture)

func apertureChanged(a):
	aperture = a
	if(Engine.editor_hint):
		for i in coins.size():
			coins[i].position.x = i * distance
			coins[i].position.y = -amplitude * sin(coins[i].position.x / aperture)

func deleteCoins():
	coins.clear()
	for i in range(get_child_count() - 1):
		get_child(i + 1).queue_free()
