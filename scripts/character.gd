extends KinematicBody2D

enum States {IDLE, RUN, JUMP, DOUBLEJUMP, WALLSLIDE, WALLJUMP, GLIDE, FALL, HIT, BOUNCE, PUSHBACK, LEVELCOMPLETED}
var state
var statePrevious

var velocity = Vector2()
var velocityGlide = Vector2()
var speed
var floorNormal = Vector2(0, -1)
var direction = 0
var floorLimit
var jumped = false

const GRAVITY = 100
const JUMPFORCE = -1800
const RUNSPEED = 800
const AIRFRICTION = 0.05
const WALLFRICTION = 0.18
const BOUNCEFORCE = -3000

onready var feet = $Feet
onready var front = $Front
onready var back = $Back
onready var anim = $Animation
onready var particleDust = $Dust
onready var trail = $Trail

func _ready():
	particleDust.hide()
	speed = RUNSPEED
	state = StateIdle.new(self)
	statePrevious = state
	floorLimit = get_viewport_rect().size.y + 200
	add_to_group(assets.GROUP_CHARACTERS)

func _physics_process(delta):
	state.update(delta)
	
func _input(event):
	state.input(event)
	
func setState(newState):
	statePrevious = state
	state.exit()
	if(newState == States.IDLE):
		state = StateIdle.new(self)
	elif(newState == States.RUN):
		state = StateRun.new(self)
	elif(newState == States.JUMP):
		state = StateJump.new(self)
	elif(newState == States.DOUBLEJUMP):
		state = StateDoubleJump.new(self)
	elif(newState == States.WALLSLIDE):
		state = StateWallSlide.new(self)
	elif(newState == States.WALLJUMP):
		state = StateWallJump.new(self)
	elif(newState == States.GLIDE):
		state = StateGlide.new(self)
	elif(newState == States.FALL):
		state = StateFall.new(self)
	elif(newState == States.HIT):
		state = StateHit.new(self)
	elif(newState == States.BOUNCE):
		state = StateBounce.new(self)
	elif(newState == States.PUSHBACK):
		state = StatePushBack.new(self)
	elif(newState == States.LEVELCOMPLETED):
		state = StateLevelCompleted.new(self)
		
func getState():
	if(state is StateIdle):
		return States.IDLE
	elif(state is StateRun):
		return States.RUN
	elif(state is StateJump):
		return States.JUMP
	elif(state is StateDoubleJump):
		return States.DOUBLEJUMP
	elif(state is StateWallSlide):
		return States.WALLSLIDE
	elif(state is StateWallJump):
		return States.WALLJUMP
	elif(state is StateGlide):
		return States.GLIDE
	elif(state is StateFall):
		return States.FALL
	elif(state is StateHit):
		return States.HIT
	elif(state is StateBounce):
		return States.BOUNCE
	elif(state is StatePushBack):
		return States.PUSHBACK
	elif(state is StateLevelCompleted):
		return States.LEVELCOMPLETED

func flipBody(value):
	$Body.scale.x = value

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
			global.emit_signal("levelStarted")
			player.setState(player.States.RUN)
		if(event.is_action_pressed("ui_home")):
			player.get_tree().change_scene("res://stages/play.tscn")
		
	func exit():
		player.anim.play("reset")

class StateRun:
	
	var player: KinematicBody2D
	var jumpTimeOffset
	var timeStarted
	const TIME_OFFSET = 0.06
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.flipBody(1.0)
		self.player.direction = 1
		self.player.anim.play("running")
		self.player.jumped = false
		self.player.velocityGlide.y = 0
		self.player.particleDust.emitting = true
		self.player.particleDust.restart()
		self.player.particleDust.show()
		self.player.trail.showTrail(false)
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
			if(jumpTimeOffset >= TIME_OFFSET):
				player.setState(player.States.FALL)
		if(player.front.is_colliding()):
			player.setState(player.States.PUSHBACK)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.feet.is_colliding() or jumpTimeOffset <= TIME_OFFSET):
				player.setState(player.States.JUMP)
		
		if(event.is_action_pressed("ui_home")):
			player.get_tree().change_scene(assets.MENU_PLAY)
		if(Input.is_key_pressed(KEY_I)):
			player.setState(player.States.IDLE)
		
	func exit():
		player.anim.play("reset")
		player.particleDust.emitting = false
		player.particleDust.hide()
		player.trail.showTrail(true)

class StatePushBack:
	
	var player: KinematicBody2D
	var acceleration = 2000.0
	var initialPositionX
	const DISTANCE = 200
	const ACCELERATION_MIN = 50.0
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.jumped = false
		self.player.anim.play("pushback")
		self.player.trail.showTrail(false)
		initialPositionX = player.position.x
	
	func update(delta):
		player.velocity.x = -acceleration
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.is_on_floor()):
			player.velocity.y = 0
		if(not player.feet.is_colliding()):
			player.setState(player.States.FALL)
		
		if(player.position.x < initialPositionX - DISTANCE):
			player.setState(player.States.RUN)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.feet.is_colliding()):
				player.setState(player.States.JUMP)
		
		if(event.is_action_pressed("ui_home")):
			player.get_tree().change_scene(assets.MENU_PLAY)
		
	func exit():
		player.anim.play("reset")
		player.trail.showTrail(true)

class StateJump:
	
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
			player.setState(player.States.FALL)
		elif(player.is_on_ceiling()):
			player.velocity.y = 0
		elif(player.is_on_floor()):
			player.setState(player.States.RUN)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding() or player.back.is_colliding()):
				player.setState(player.States.WALLJUMP)
			else:
				if(global.doubleJumpUnlocked):
					player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_pressed("tap_left")):
			if(global.glideUnlocked):
				player.setState(player.States.GLIDE)
		
	func exit():
		player.anim.stop()
		pass
		
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
			player.setState(player.States.FALL)
		elif(player.is_on_ceiling()):
			player.velocity.y = 0
		elif(player.is_on_floor()):
			player.setState(player.States.RUN)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding() or player.back.is_colliding()):
				player.setState(player.States.WALLJUMP)
		if(event.is_action_pressed("tap_left")):
			if(global.glideUnlocked):
				player.setState(player.States.GLIDE)
		
	func exit():
		player.anim.play("reset")
		
class StateWallJump:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.velocity.y = self.player.JUMPFORCE
		self.player.jumped = true
		if(not self.player.statePrevious is StateWallSlide):
			self.player.direction *= -1
			self.player.flipBody(self.player.direction)
		self.player.anim.play("walljump")
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.velocity.y >= 0):
			player.setState(player.States.FALL)
		elif(player.is_on_ceiling()):
			player.velocity.y = 0
		elif(player.is_on_floor()):
			player.setState(player.States.RUN)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(global.doubleJumpUnlocked):
				player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_pressed("tap_left")):
			if(global.glideUnlocked):
				player.setState(player.States.GLIDE)
		
	func exit():
		player.anim.play("reset")
		
class StateWallSlide:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.direction *= -1
		self.player.flipBody(self.player.direction)
		self.player.velocity.x = 0
		self.player.velocity.y = 0
		self.player.anim.play("wallslide")
		
	func update(delta):
		if(player.back.is_colliding() or player.front.is_colliding()):
			player.velocity.y += player.GRAVITY * player.WALLFRICTION
		else:
			player.velocity.y += player.GRAVITY
			player.anim.play("falling")
		
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.is_on_ceiling()):
			player.velocity.y = 0
		elif(player.is_on_floor()):
			player.setState(player.States.RUN)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding() or player.back.is_colliding()):
				player.setState(player.States.WALLJUMP)
		
	func exit():
		player.anim.play("reset")

class StateGlide:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		if(self.player.statePrevious is StateFall):
			self.player.velocity.y = self.player.velocityGlide.y
		else:
			self.player.velocity.y = 0
		self.player.anim.play("gliding")
		self.player.trail.showTrail(false)
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY * player.AIRFRICTION
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.is_on_ceiling()):
			player.velocity.y = 0
		elif(player.is_on_floor()):
			player.setState(player.States.RUN)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding() or player.back.is_colliding()):
				player.setState(player.States.WALLJUMP)
			else:
				if(player.jumped and global.doubleJumpUnlocked):
					player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_released("tap_left")):
			player.setState(player.States.FALL)
		
	func exit():
		player.anim.play("reset")
		player.velocityGlide = player.velocity
		player.trail.showTrail(true)
		
class StateFall:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		if(not self.player.statePrevious is StateGlide):
			self.player.velocity.y = 0
		self.player.anim.play("falling")
		
	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.front.is_colliding() or player.back.is_colliding()):
			player.setState(player.States.WALLSLIDE)
		elif(player.global_position.y >= player.floorLimit):
			player.setState(player.States.HIT)
		elif(player.is_on_floor()):
			player.setState(player.States.RUN)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding() or player.back.is_colliding()):
				player.setState(player.States.WALLJUMP)
			else:
				if(player.jumped and global.doubleJumpUnlocked):
					player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_pressed("tap_left")):
			if(global.glideUnlocked):
				player.setState(player.States.GLIDE)
		
	func exit():
		player.anim.play("reset")
		
class StateHit:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		global.emit_signal("stateHit")
		
	func update(delta):
		pass
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			pass
		if(event.is_action_pressed("tap_left")):
			pass
		if(event.is_action_pressed("ui_home")):
			player.get_tree().change_scene(assets.MENU_PLAY)
		
	func exit():
		player.anim.play("reset")
		
class StateBounce:
	
	var player: KinematicBody2D
	
	func _init(player: KinematicBody2D):
		self.player = player
		self.player.velocity.y = player.BOUNCEFORCE
		self.player.anim.play("doublejump")

	func update(delta):
		player.velocity.x = player.direction * player.speed
		player.velocity.y += player.GRAVITY
		player.move_and_slide(player.velocity, player.floorNormal)
		
		if(player.velocity.y >= 0):
			player.setState(player.States.FALL)
		elif(player.is_on_ceiling()):
			player.velocity.y = 0
		elif(player.is_on_floor()):
			player.setState(player.States.RUN)
		
	func input(event: InputEvent):
		if(event.is_action_pressed("tap_right")):
			if(player.front.is_colliding() or player.back.is_colliding()):
				player.setState(player.States.WALLJUMP)
			else:
				if(player.jumped and global.doubleJumpUnlocked):
					player.setState(player.States.DOUBLEJUMP)
		if(event.is_action_pressed("tap_left")):
			if(global.glideUnlocked):
				player.setState(player.States.GLIDE)
		
	func exit():
		player.anim.play("reset")

class StateLevelCompleted:
	
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
		pass
		
	func exit():
		player.anim.play("reset")
