extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_margin: float = 64.0
@export var screen_padding: float = 32.0

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")



func _on_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	if enemy_scene == null:
		return
	
	
	var enemy = enemy_scene.instantiate() as EnemyBasic
	get_parent().add_child(enemy)
	
	enemy.global_position = get_random_position_outside_screen()
	if is_instance_valid(player):
		enemy.damage_player.connect(player.take_damage)
	
func get_random_position_outside_screen() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var side = randi_range(0, 3)
	
	match side:
		0:
			return Vector2(
				randf_range(0, viewport_size.x),
				-spawn_margin
			)
		1:
			return Vector2(
				randf_range(0, viewport_size.x),
				viewport_size.y + spawn_margin
			)
		2:
			return Vector2(
				-spawn_margin,
				randf_range(0, viewport_size.y)					
			)
		_:
			return Vector2(
				viewport_size.x + spawn_margin,
				randf_range(0, viewport_size.y)					
			)
