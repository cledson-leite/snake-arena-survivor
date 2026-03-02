extends CharacterBody2D

@export var max_speed: float = 250.0
@export var acceleration: float = 800.0
@export var deceleration: float = 600.0
@export var rotation_speed: float = 10.0

func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector(
		"left", "right", "up", "down"
	)
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(
			input_direction * max_speed,
			acceleration * delta
		)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	if velocity.length() > 1.0:
		var target_rotation := velocity.angle()
		rotation = lerp_angle(
			rotation,
			target_rotation,
			rotation_speed * delta
		)
	
	move_and_slide()
