extends KinematicBody2D

enum States{IDLE, RUNNING, JUMPING, DOUBLEJUMP, WALLJUMP, WALLFALL, GLIDING, FALLING, HIT, BOUNCE}
var state

var velocity = Vector2()
var speed
var floorNormal = Vector2(0, -1)
var direction = 0

const GRAVITY = 100
const JUMPFORCE = -1700
const RUNSPEED = 600
const AIRFRICTION = 0.05
const WALLFRICTION = 0.4
const BOUNCEFORCE = -2600

var jumped = false

onready var feet = $Feet
onready var front = $Front
onready var anim = $Animation

var floorLimit

func _ready():
	add_to_group(assets.groupPlayer)
	speed = RUNSPEED
	state = StateIdle.new(self)
	floorLimit = get_viewport_rect().size.y + 200
	
func _physics_process(delta):
	state.update(delta)
	
func _input(event):
	state.input(event)
	
func setState(newState):
	state.exit()
	if(newState == States.IDLE):
		state = StateIdle.new(self)
	elif(newState == States.RUNNING):
		state = StateRunning.new(self)
	elif(newState == States.JUMPING):
		state = StateJumping.new(self)
	elif(newState == States.DOUBLEJUMP):
		state = StateDoubleJump.new(self)
	elif(newState == States.WALLJUMP):
		state = StateWallJump.new(self)
	elif(newState == States.WALLFALL):
		state = StateWallFall.new(self)
	elif(newState == States.GLIDING):
		state = StateGliding.new(self)
	elif(newState == States.FALLING):
		state = StateFalling.new(self)
	elif(newState == States.HIT):
		state = StateHit.new(self)
	elif(newState == States.BOUNCE):
		state = StateBounce.new(self)
		
func getState():
	if(state is StateIdle):
		return States.IDLE
	elif(state is StateRunning):
		return States.RUNNING
	elif(state is StateJumping):
		return States.JUMPING
	elif(state is StateDoubleJump):
		return States.DOUBLEJUMP
	elif(state is StateWallJump):
		return States.WALLJUMP
	elif(state is StateWallFall):
		return States.WALLFALL
	elif(state is StateGliding):
		return States.GLIDING
	elif(state is StateFalling):
		return States.FALLING
	elif(state is StateHit):
		return States.HIT
	elif(state is StateBounce):
		return States.BOUNCE

#----------------------CLASSES-------------------------#

class StateIdle:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.anim.play("idle")
		self.player.direction = 0
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		if(player.is_on_floor()):
			player.velocity.y = 0
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding()):
				player.setState(player.States.JUMPING)
				player.direction = 1
			else:
				player.setState(player.States.RUNNING)
		if(event.is_action_pressed("ui_home")):
			player.get_tree().change_scene("res://stages/play.tscn")
		
	func exit():
		player.anim.stop(true)

class StateRunning:
	
	var player: KinematicBody2D
	var jumpTimeOffset
	var timeStarted
	const TIME_OFFSET = 0.08
	
	func _init(player: KinematicBody2D):
		self.player = player
		if(self.player.direction == -1):
			self.player.scale.x *= -1
		self.player.direction = 1
		self.player.anim.play("running")
		self.player.jumped = false
		jumpTimeOffset = 0
		timeStarted = false
	
	func update(delta):
		if(timeStarted): jumpTimeOffset += delta
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		if(player.is_on_floor()):
			player.velocity.y = 0
		if(not player.feet.is_colliding()):
			timeStarted = true
			if(jumpTimeOffset >= TIME_OFFSET): player.setState(player.States.FALLING)
		if(player.front.is_colliding()):
			player.setState(player.States.IDLE)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
#			timeStarted = true
			if(player.feet.is_colliding() or jumpTimeOffset <= TIME_OFFSET):
				player.setState(player.States.JUMPING)
		if(event.is_action_pressed("tap_left")):
			if(not player.feet.is_colliding()):
				player.setState(player.States.GLIDING)
		
		if(event.is_action_pressed("ui_home")):
			player.get_tree().change_scene("res://stages/play.tscn")
		
	func exit():
		player.anim.stop(true)
		
class StateJumping:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.velocity.y = self.player.JUMPFORCE
		self.player.anim.play("jump")
		self.player.jumped = true
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.velocity.y >= 0):
			player.setState(player.States.FALLING)
		if(player.is_on_ceiling()):
			player.velocity.y = 0
		if(player.is_on_floor()):
			player.setState(player.States.RUNNING)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding()):
				if(player.front.get_collider().is_in_group(assets.groupWalls)):
					player.setState(player.States.WALLJUMP)
			else:
				player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_pressed("tap_left")):
			player.setState(player.States.GLIDING)
		
	func exit():
		player.anim.stop(true)
		
class StateDoubleJump:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.velocity.y = self.player.JUMPFORCE
		self.player.anim.play("doublejump")
		self.player.jumped = false
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.velocity.y >= 0):
			player.setState(player.States.FALLING)
		if(player.is_on_ceiling()):
			player.velocity.y = 0
		if(player.is_on_floor()):
			player.setState(player.States.RUNNING)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding()):
				if(player.front.get_collider().is_in_group(assets.groupWalls)):
					player.setState(player.States.WALLJUMP)
		if(event.is_action_pressed("tap_left")):
			player.setState(player.States.GLIDING)
		
	func exit():
		player.anim.stop(true)
		
class StateWallJump:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.direction *= -1
		self.player.scale.x *= -1
		self.player.velocity.y = self.player.JUMPFORCE
		self.player.anim.play("walljump")
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.front.is_colliding()):
			player.setState(player.States.WALLFALL)
		if(player.is_on_ceiling()):
			player.velocity.y = 0
		if(player.is_on_floor()):
			player.setState(player.States.RUNNING)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			pass
		
	func exit():
#		if(player.direction == -1):
#			player.direction = 1
#			player.scale.x *= -1
		player.anim.stop(true)

class StateWallFall:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.velocity.y = 0
		#self.player.anim.play("walljump")
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY * WALLFRICTION
		
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(not player.front.is_colliding()):
			player.setState(player.States.FALLING)
		if(player.is_on_ceiling()):
			player.velocity.y = 0
		if(player.is_on_floor()):
			player.setState(player.States.RUNNING)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			player.setState(player.States.WALLJUMP)
		
	func exit():
#		if(player.direction == -1):
#			player.direction = 1
#			player.scale.x *= -1
#		player.anim.stop(true)
		pass

class StateGliding:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.velocity.y = 0
		self.player.get_node("Parachutes").show()
		self.player.get_node("Body").rotation = 0
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY * player.AIRFRICTION
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.is_on_ceiling()):
			player.velocity.y = 0
		if(player.is_on_floor()):
			player.setState(player.States.RUNNING)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.jumped):
				player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_released("tap_left")):
			player.setState(player.States.FALLING)
		
	func exit():
		player.anim.stop(true)
		self.player.get_node("Parachutes").hide()
		
class StateFalling:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.velocity.y = 0
		self.player.anim.play("falling")
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.global_position.y >= player.floorLimit):
			player.setState(player.States.HIT)
		if(player.is_on_floor()):
			player.setState(player.States.RUNNING)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding()):
				if(player.front.get_collider().is_in_group(assets.groupWalls)):
					player.setState(player.States.WALLJUMP)
			elif(player.jumped):
				player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_pressed("tap_left")):
			player.setState(player.States.GLIDING)
		
	func exit():
		player.anim.stop(true)
		
class StateHit:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		app.emit_signal("stateHit")
		
	func update(delta):
		pass
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			pass
		if(event.is_action_pressed("tap_left")):
			pass
		if(event.is_action_pressed("ui_home")):
			player.get_tree().change_scene("res://stages/play.tscn")
		
	func exit():
		player.anim.stop(true)
		
class StateBounce:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.velocity.y = player.BOUNCEFORCE
		self.player.anim.play("jump")

	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.is_on_ceiling()):
			player.velocity.y = 0
		if(player.is_on_floor()):
			player.setState(player.States.RUNNING)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding()):
				if(player.front.get_collider().is_in_group(assets.groupWalls)):
					player.setState(player.States.WALLJUMP)
			elif(player.jumped):
				player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_pressed("tap_left")):
			player.setState(player.States.GLIDING)
		
	func exit():
		player.anim.stop(true)