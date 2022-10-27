tool
extends StaticBody2D

export(Texture) var texture = null setget setTexture

func setTexture(newTexture):
	texture = newTexture
	$Sprite.texture = texture
