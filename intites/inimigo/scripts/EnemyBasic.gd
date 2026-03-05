class_name EnemyBasic

extends CharacterBody2D

signal damage_player()

@export var speed: float = 100.0

@onready var player : Node2D = get_tree().get_first_node_in_group("player")

var has_hit_player: bool = false


func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	var direction := (player.global_position - global_position).normalized()
	velocity = direction * speed
	
	var collision = move_and_collide(velocity * delta)
	
	if collision and not has_hit_player:
		var collider = collision.get_collider()
		
		if collider == player:
			has_hit_player = true
			emit_signal("damage_player")
			queue_free()
