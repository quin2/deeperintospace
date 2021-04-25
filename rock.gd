extends RigidBody2D

export var object_type = "planet"

func _ready():
	
	var planet_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = planet_types[randi() % planet_types.size()]

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass
