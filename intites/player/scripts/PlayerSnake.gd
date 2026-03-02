extends CharacterBody2D

@export var max_speed: float = 250.0
@export var acceleration: float = 800.0
@export var deceleration: float = 600.0
@export var rotation_speed: float = 10.0

@export var segment_spacing: float = 32.0
@export var max_segments: int = 20

var last_position_head: Vector2

var position_history: Array[Vector2] = []
var body_segments: Array[Node2D] = []

@onready var body_scene := preload("res://intites/player/BodySegment.tscn")

func _ready() -> void:
	last_position_head = global_position
	var history_lenght := max_segments * segment_spacing
	for i in range(history_lenght):
		position_history.append(global_position)
		
	for i in 3:
		add_body_segment(body_scene)

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
	
	var distance := global_position.distance_to(last_position_head)
	if distance >= 1.0:
		var direction := (global_position - last_position_head).normalized()
		for i in range(int(distance)):
			last_position_head += direction
			position_history.push_front(last_position_head)
			
	var max_history_size := max_segments * segment_spacing
	while position_history.size() > max_history_size:
		position_history.pop_back()
	
	for i in body_segments.size():
		var history_index := (i+1) * segment_spacing
		
		if history_index < position_history.size():
			body_segments[i].global_position = position_history[history_index]

func add_body_segment(scene: PackedScene) -> void:
	if body_segments.size() >= max_segments:
		return
	var segment = scene.instantiate() as Node2D
	add_child(segment)
	
	segment.global_position = global_position
	body_segments.append(segment)
