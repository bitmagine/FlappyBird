# script: bird
extends RigidBody2D

onready var state = FlyingState.new(self)
const STATE_FLYING		= 0
const STATE_FLAPPING		= 1
const STATE_HIT			= 2
const STATE_GROUNDED		= 3
var speed = 50

func _ready():
	pass
func _physics_process(delta):	
	state.update(delta)
func _input(event):
	state.input(event)
func set_state(new_state):
	state.exit()
	if new_state == STATE_FLYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAPPING:
		state = FlappingState.new(self)
	elif new_state == STATE_HIT:
		state = HitState.new(self)
	elif new_state == STATE_GROUNDED:
		state = GroundedState.new(self)
	pass
func get_state():
	if state is FlyingState:
		return  STATE_FLYING
	elif state is FlappingState:
		return  STATE_FLAPPING
	elif state is HitState:
		return  STATE_HIT
	elif state is GroundedState:
		return  STATE_GROUNDED

# state management classes
class FlyingState:
	var bird
	var prev_gravity_scale
	func _init(bird):
		self.bird = bird
		bird.get_node("anim").play("flying")
		prev_gravity_scale = bird.get_gravity_scale()
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))
		bird.set_gravity_scale(0)
		pass
	func update(delta):
		pass	
	func input(event):
		pass
	func exit():
		bird.set_gravity_scale(prev_gravity_scale)
		pass
		
class FlappingState:
	var bird
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))
	func update(delta):
		if bird.rotation < deg2rad(-30):
			bird.rotation = deg2rad(-30)
			bird.set_angular_velocity(0)
		if bird.get_linear_velocity().y > 0:
			bird.set_angular_velocity(1.5)
	func input(event):
		if event.is_action_pressed("flap"):
			flap()
	func exit():
		pass
	func flap():
		bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x, -150))
		bird.set_angular_velocity(-3)
		bird.get_node("anim").play("flap")

class HitState:
	var bird
	func _init(bird):
		self.bird = bird
		pass
	func update(delta):
		pass	
	func input(event):
		pass
	func exit():
		pass

class GroundedState:
	var bird
	func _init(bird):
		self.bird = bird
		pass
	func update(delta):
		pass	
	func input(event):
		pass
	func exit():
		pass
