extends RigidBody2D

export (int) var engine_thrust = 100
export (int) var spin_thrust = 1500

signal hit
signal updateBoost

var thrust = Vector2()
var rotation_dir = 0
var screensize
var my_position
var pos_reset = false
var boostLevel = 100

func _ready():
	screensize = get_viewport().get_visible_rect().size

func get_input():
	if Input.is_action_pressed("boost") and boostLevel > 0:
		thrust = Vector2(engine_thrust, 0)
		$AnimatedSprite.play()
		changeBoostLevel(-0.5)
	else:
		thrust = Vector2()
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()
	rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1

func _process(delta):
	get_input()

func _physics_process(delta):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)
	
func _integrate_forces(state):
	var xform = state.get_transform()
	if pos_reset:
		xform.origin = my_position
		xform = xform.rotated(0.0)
		pos_reset = false
		show()
	else:
		xform.origin.x = clamp(xform.origin.x, 0, screensize.x)
		xform.origin.y = clamp(xform.origin.y, 0, screensize.y)
	state.set_transform(xform)
	
func _on_Player_body_entered(body):
	emit_signal("hit", body)

func disablePhysics():
	$CollisionPolygon2D.set_deferred("disabled", true)

func changeBoostLevel(value):
	if (boostLevel + value) < 0:
		boostLevel = 0
	elif (boostLevel + value) > 100:
		boostLevel = 100
	else:
		boostLevel += value
	emit_signal("updateBoost",boostLevel)

func start(pos):
	my_position = pos
	pos_reset = true
	#show()
	$CollisionPolygon2D.disabled = false
